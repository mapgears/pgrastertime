
CREATE OR REPLACE FUNCTION public.dfo_most_recent(
	filename character varying,
	tablename character varying,
	manage_older boolean default true)
    RETURNS text
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE STRICT 
AS $BODY$
DECLARE
	rec RECORD;
	rec1 RECORD;
    query text;
	geom geometry(multipolygon,3979);
	blnstop boolean;
	query_init text;
ret text;
BEGIN
  raise notice 'older : %', manage_older;
	drop table if exists tmp_to_invalidate; 

/**Determine all tiles older than the inserted ones that have to be invalidated **/
	EXECUTE concat('create temporary table tmp_to_invalidate as 
	with t as ( SELECT s.id,max(lower(snew.sys_period)) as date , st_area( st_difference( s.tile_geom, st_union(snew.tile_geom)))=0 as a --, st_union(snew.tile_geom), s.tile_geom, st_area( st_difference( s.tile_geom, st_union(snew.tile_geom)))=0,st_difference( s.tile_geom, st_union(snew.tile_geom))  
	from ',tablename,' s 
		join ',tablename,' snew on st_intersects(s.tile_geom,snew.tile_geom)
	where snew.filename like ',quote_literal(filename||'%'),'
		and lower (s.sys_period) < lower(snew.sys_period)  --older tiles
		and (upper(s.sys_period) is null OR upper(s.sys_period) > lower(snew.sys_period))  --still valid or  invalidate by a most recent than the inserted one.
		and s.resolution=snew.resolution
	group by s.id,s.tile_geom)
	select id ,date  from t where a is true;
	');

/**If the inserted tiles are older than some existing tiles**/
if manage_older then 
	query_init:=concat( 'SELECT id,tile_geom,sys_period from ',tablename,'
						WHERE filename like ',quote_literal(filename||'%'));
	raise notice '%', query_init;
	--For all inserted tiles													   
	FOR rec1 IN EXECUTE query_init
	loop
	   raise notice 'rec1 id : %', rec1.id;
		blnstop := false;
		query := concat ('SELECT 
				s.id,s.tile_geom,lower(s.sys_period) as date
				from ',tablename,' s  join ',tablename,' snew on st_intersects(s.tile_geom,snew.tile_geom)
				where snew.id= ',rec1.id,'
				and lower (s.sys_period) > lower(snew.sys_period)  -- selecting tiles more recent than the inserted ones
				order by  lower(s.sys_period)');
		geom=null;
															
		--For all newer tiles intersecting the current tile.
		FOR rec IN EXECUTE query 
		LOOP

			if blnstop is false then 
				if geom is null then --first loop
					geom:=st_multi(rec.tile_geom);
				else
					SELECT st_multi(st_union(rec.tile_geom,geom)) into geom; --add the geom to the group  
				end if;
				
				--Determine if the tile is completely covered by de "grouped" geometry
				SELECT st_area( st_difference( rec1.tile_geom, geom))=0 INTO blnStop;
				
				if blnstop then 
					raise notice '%','tile compleately covered '||rec.date;
					--EXECUTE concat('UPDATE ' ,tablename,' 
					--			   SET invalidate =  tstzrange( lower(sys_period),  ',quote_literal(rec.sys_period),')
					--			  WHERE id = ',rec1.id) ;				
						insert into tmp_to_invalidate(id,date) SELECT rec1.id ,rec.date;
					exit;
				else 
					raise notice '%','next geom'||rec.date;	
				end if;
			end if;
		END LOOP;
	END LOOP;
end if;
EXECUTE format('update %s s set sys_period = tstzrange(  lower (sys_period) , date ) 
from tmp_to_invalidate f where s.id=f.id',tablename);

    select count (*) from tmp_to_invalidate into ret;
	RETURN  ret ;
END;
$BODY$;
