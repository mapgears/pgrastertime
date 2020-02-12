-- FUNCTION: public.dfo_invalidate_tiles(character varying, character varying, boolean)

-- DROP FUNCTION public.dfo_invalidate_tiles(character varying, character varying, boolean);

CREATE OR REPLACE FUNCTION public.dfo_invalidate_tiles2(
	metadata_id character varying,
	tablename character varying,
	manage_older boolean DEFAULT true)
    RETURNS text
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE STRICT 
AS $BODY$
DECLARE
	rec RECORD;
	rec1 RECORD;
    query_ text;
	geom geometry(multipolygon,3979);
	blnstop boolean;
	query_init text;
	count_rows bigint;
	loop_count int;
ret text;
BEGIN
  -- just in case ...
  DROP TABLE IF EXISTS tmp_to_invalidate; 

  /**Determine all tiles older than the inserted ones that have to be invalidated **/
  EXECUTE concat('create temporary table tmp_to_invalidate as 
	with t as ( SELECT s.id,max(lower(snew.sys_period)) as date , st_area( st_difference( s.tile_geom, st_union(snew.tile_geom)))=0 as a 
	from ',tablename,' s 
		join ',tablename,' snew on st_intersects(s.tile_geom,snew.tile_geom)
	where snew.metadata_id = ',quote_literal(metadata_id),'
		and lower (s.sys_period) < lower(snew.sys_period)  --older tiles
		and (upper(s.sys_period) is null OR upper(s.sys_period) > lower(snew.sys_period))  --still valid or  invalidate by a most recent than the inserted one.
	group by s.id,s.tile_geom)
	select id ,date  from t where a is true;
	');

  /**If the inserted tiles are older than some existing tiles**/
  IF manage_older THEN 
    -- counter for debuging
    SELECT count(*) INTO count_rows;
	
    EXECUTE concat('SELECT count(*) from ',tablename,' WHERE metadata_id = ', quote_literal(metadata_id)) INTO count_rows; 
	query_init:=concat( 'SELECT id,tile_geom,sys_period from ',tablename,' WHERE metadata_id = ',quote_literal(metadata_id));

	--For all inserted tiles	
	loop_count := 1;
	FOR rec1 IN EXECUTE query_init
	loop
	   RAISE NOTICE '%', 'Row id: ' || rec1.id || ' / metadata_id: ' || metadata_id || ' ( ' || loop_count|| ' of '|| count_rows  || ' )';
	   loop_count := loop_count +1;
	   blnstop := false;
	   query_ := concat ('SELECT 
				s.id,s.tile_geom,lower(s.sys_period) as date
				from ',tablename,' s  join ',tablename,' snew on st_intersects(s.tile_geom,snew.tile_geom)
				where snew.id= ',rec1.id,'
				and lower (s.sys_period) > lower(snew.sys_period)  -- selecting tiles more recent than the inserted ones
				order by  lower(s.sys_period)');
		geom=null;
															
		--For all newer tiles intersecting the current tile.
		FOR rec IN EXECUTE query_ 
		LOOP
			IF blnstop IS false THEN 
				IF geom IS null THEN --first loop
					geom:=st_multi(rec.tile_geom);
				ELSE
					SELECT st_multi(st_union(rec.tile_geom,geom)) INTO geom; --add the geom to the group  
				END IF;
				
				--Determine if the tile is completely covered by de "grouped" geometry
				SELECT st_area( st_difference( rec1.tile_geom, geom))=0 INTO blnStop;
				
				IF blnstop THEN 
					RAISE NOTICE '%','Tile compleately covered '||rec.date;
					    --EXECUTE concat('UPDATE ' ,tablename,' 
					    --			   SET invalidate =  tstzrange( lower(sys_period),  ',quote_literal(rec.sys_period),')
					    --			   WHERE id = ',rec1.id) ;	
						-- NOTE: Update throught tmp table to improve the process
						INSERT INTO tmp_to_invalidate(id,date) SELECT rec1.id ,rec.date;
					EXIT;
				ELSE 
					RAISE NOTICE '%','Loop for next tile geom '||rec.date;	
				END IF;
			END IF;
		END LOOP;
	END LOOP;
  END IF;
  EXECUTE format('update %s s set sys_period = tstzrange(  lower (sys_period) , date ) from tmp_to_invalidate f where s.id=f.id',tablename);

  SELECT COUNT (*) FROM tmp_to_invalidate into ret;
  RAISE NOTICE '%', 'Total of ' || ret || ' tiles compleately covered.';
  RETURN ret;
END;
$BODY$;

