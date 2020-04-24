-- FUNCTION: public.dfo_invalidate_tiles(character varying, character varying, boolean)

DROP FUNCTION public.dfo_invalidate_tiles(character varying, character varying, boolean);

CREATE OR REPLACE FUNCTION public.dfo_invalidate_tiles(
	metadata_id character varying,
	tablename character varying,
	manage_older boolean DEFAULT true,
	txt_counter_rows text DEFAULT ''::text)
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


-- TODO, find a new way to invalidate tiles for 1m, 50cm and 25cm.  The actual method is too slow.  
-- the dfo_invalidate_tiles contains 3 queries that never respond.  Needs deeper analysis to find why.
-- By removing those resolution, we bypass the problem for now.


  EXECUTE concat('DROP TABLE IF EXISTS tmp_to_invalidate_',tablename); 

  -- Determine all tiles older than the inserted ones that have to be invalidated
  RAISE NOTICE '%', 'Determine all tiles older...';
  -- TODO this query can be slow
   query_init := concat('CREATE TEMPORARY TABLE tmp_to_invalidate_',tablename,' AS 
	WITH t AS ( SELECT s.id,max(lower(snew.sys_period)) AS date , st_area( st_difference( s.tile_geom, st_union(snew.tile_geom)))=0 as a 
	FROM ',tablename,' s JOIN ',tablename,' snew on st_intersects(s.tile_geom,snew.tile_geom)
	WHERE snew.metadata_id = ',quote_literal(metadata_id),'
		AND lower (s.sys_period) < lower(snew.sys_period)  --older tiles
		AND (upper(s.sys_period) IS NULL OR upper(s.sys_period) > lower(snew.sys_period))  --still valid or  invalidate by a most recent than the inserted one.
	GROUP BY s.id,s.tile_geom)
	SELECT id ,date  FROM t WHERE a IS TRUE;');
   
   RAISE NOTICE '%', query_init;
   EXECUTE query_init;

  -- If the inserted tiles are older than some existing tiles
  IF manage_older THEN 
    
	-- counter for debuging
    EXECUTE concat('SELECT count(*) from ',tablename,' WHERE metadata_id = ', quote_literal(metadata_id)) INTO count_rows; 
	query_init := concat( 'SELECT id,tile_geom,sys_period from ',tablename,' WHERE metadata_id = ',quote_literal(metadata_id));

	-- For all inserted tiles	
	loop_count := 1;
	FOR rec1 IN EXECUTE query_init
	LOOP
	   RAISE NOTICE '%', 'Row id: ' || rec1.id || ' ( ' || loop_count || 
	                      ' of '|| count_rows  || ' ) / metadata_id: ' || 
						  metadata_id || ' ' || txt_counter_rows ;
	   loop_count := loop_count +1;
	   blnstop := false;
	   RAISE NOTICE '%', 'Collect newer rows than the one already inserted...';
	   query_ := concat ('SELECT 
				s.id,s.tile_geom,lower(s.sys_period) AS date
				FROM ',tablename,' s  JOIN ',tablename,' snew ON ST_Intersects(s.tile_geom,snew.tile_geom)
				WHERE snew.id= ',rec1.id,'
				AND lower(s.sys_period) > lower(snew.sys_period)  -- selecting tiles more recent than the inserted ones
				ORDER BY lower(s.sys_period)');
		geom=NULL;
															
		-- For all newer tiles intersecting the current tile.
		FOR rec IN EXECUTE query_ 
		LOOP
			IF blnstop IS false THEN 
				IF geom IS NULL THEN --first loop
					geom:=ST_Multi(rec.tile_geom);
				ELSE
				    RAISE NOTICE '%','Add the tile geom to the grouped geom...';
					  -- TODO this query can be slow
					SELECT ST_Multi(ST_Union(rec.tile_geom,geom)) INTO geom; --add the geom to the group  
				END IF;
				
				-- Determine if the tile is completely covered by de "grouped" geometry
				RAISE NOTICE '%','Determine if completely covered...';
				  -- TODO this query can be very slow
				SELECT ST_Area( ST_Difference( rec1.tile_geom, geom))=0 INTO blnStop;
				
				IF blnstop THEN 
					RAISE NOTICE '%','Tile compleately covered, insert into tmp table whit date:'||rec.date;
					    --EXECUTE concat('UPDATE ' ,tablename,' 
					    --			   SET invalidate =  tstzrange( lower(sys_period),  ',quote_literal(rec.sys_period),')
					    --			   WHERE id = ',rec1.id) ;	
						-- NOTE: Update throught tmp table to improve the process
						EXECUTE concat('INSERT INTO tmp_to_invalidate_',tablename,
									   '(id,date) VALUES(',quote_literal(rec1.id),',',
									   quote_literal(rec.date),')');
					EXIT;
				ELSE 
					RAISE NOTICE '%','Loop for next tile geom '||rec.date;	
				END IF;
			END IF;
		END LOOP;
	END LOOP;
  END IF;
  EXECUTE format('UPDATE %s s SET sys_period = tstzrange(  lower (sys_period) , date ) FROM tmp_to_invalidate_%s f WHERE s.id=f.id',tablename,tablename);

  EXECUTE concat('SELECT COUNT (*) FROM tmp_to_invalidate_',tablename) into ret;
  RAISE NOTICE '%', 'Total of ' || ret || ' tiles compleately covered.';
  RETURN ret;
END;
$BODY$;

