CREATE OR REPLACE FUNCTION public.dfo_add_conformance_band(
	rastertable text,
	sectortable text,
	sectorgeom text,
	resolution numeric,
	filename text)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$

DECLARE
	state text;
	nbands integer;
	rastcol text;
	strsql text;
BEGIN

--get the raster column name from catalog
SELECT r_raster_column FROM raster_columns WHERE r_table_name = rastertable INTO rastcol;

--create a temporary table being the clip  of the raster on his intersecting geometries of the sector table (containing the disign grade)
--for a particular resolution and filename.
strsql:= concat( 'drop  table  if exists tmp_clip_to_conformance;
create temporary table tmp_clip_to_conformance as
select id,st_clip(',rastcol,',  ',sectorgeom,' ,false) as raster , maintained, gid   
from ' ,rasterTable,'  JOIN ',sectorTable,' s ON st_intersects(tile_extent , ',sectorgeom,')
WHERE filename like ' , quote_literal(filename||'%'), ' AND resolution = ',resolution);
raise notice '%',strsql;
EXECUTE strsql;

--create a second temporary table calculating the "conformance" by map algebra. 
drop  table if exists tmp_conformance_algebra;			 
create temporary table tmp_conformance_algebra as select 
id, ST_MapAlgebra(raster, 1, NULL, concat(maintained,'+[rast.val]')) as raster 
FROM tmp_clip_to_conformance;

--create a third temporary table containing the union of all potentiel part of the same tile
--having clipped on several design grade.
drop  table if exists tmp_conformance;
create temporary table tmp_conformance as 				  
select id, st_union(raster) as raster from tmp_conformance_algebra group by id ;

--Update the original raster by adding the band genarated in the tmp_conformance table. 
strsql := concat('update ',rasterTable,' o 
			set ',rastcol,' =  ST_AddBand(o.',rastcol,', co.raster , 1)
			from tmp_conformance co where  co.id=o.id');		
EXECUTE strsql;		

--add un null 'conformance' band for tile that are not intersecting any zone (possible for soundings witch excede the chanel) 
strsql = concat ('UPDATE ',rasterTable,'
                  SET ',rastcol,' = ST_AddBand(',rastcol,', --destination raster.
                                        ST_BandPixelType(',rastcol,',1), --pixel type
                                        ST_BandNoDataValue(',rastcol,',1), -- assign nodata value to all pixels
                                        ST_BandNoDataValue(',rastcol,',1)) -- assign nodata value to raster 
				  WHERE filename like ' , quote_literal(filename||'%'), ' 
				  AND resolution = ',resolution, ' 
				  AND st_numbands(',rastcol,')=4');

	EXECUTE strsql;
										  
raise debug 'Update Band: %', strsql;			  

exception when others then
	raise exception ' % ', SQLERRM;

END;

$BODY$;

CREATE OR REPLACE FUNCTION public.dfo_calculate_tile_extents(
	rastertable text,
	filename text)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$

	DECLARE
      rastcol text;
	  strsql text;
	BEGIN

	SELECT r_raster_column FROM raster_columns WHERE r_table_name = rastertable INTO rastcol;

	--Setting tile extent 
	strsql = concat('UPDATE ',rastertable,' 
					 SET tile_extent = ST_Setsrid(  ST_Envelope(',rastcol,'), st_srid(',rastcol,'))
					 WHERE filename like  ', quote_literal(filename||'%'));

	 raise debug 'Update extent : % ', strsql;
	 EXECUTE strsql;

  exception when others then

      raise notice ' % ', SQLERRM;

END;

$BODY$;
CREATE OR REPLACE FUNCTION public.dfo_add_shoal_geom(
	rastertable text,
	resolution numeric,
	shoal_limit numeric,
	filename text)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$

	DECLARE
      state text;
	  strsql text;
	  rastcol text;
	BEGIN
--Shoal 
	SELECT r_raster_column FROM raster_columns WHERE r_table_name = rastertable INTO rastcol;

drop  table if exists shoal_tmp;
strsql = concat( 'create temporary table shoal_tmp
as
select
id, ST_Reclass(st_band(',rastcol,',5), 1, ''-20-',shoal_limit,'):''|| ST_BandNoDataValue( ',rastcol,',1)||'', [',shoal_limit,'-15:1'', ''4BUI'',ST_BandNoDataValue( ',rastcol,',1)  )
from ',rastertable,' 
where filename like ', quote_literal(filename||'%depth%'),'
and resolution =', resolution);

raise notice ' % ', strsql;

EXECUTE strsql;

EXECUTE format('update %s p 
                set shoal_geom = ST_Polygon(st_band(st_reclass,5))
				from shoal_tmp s
			    where p.id=s.id',rastertable);
				
  exception when others then

      raise notice ' % ', SQLERRM;

END;

$BODY$;

CREATE OR REPLACE FUNCTION public.dfo_calculate_tile_geoms(
	rastertable text,
	resolution numeric,
	filename text)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$

	DECLARE
      rastcol text;
	  strsql text;
	BEGIN

	SELECT r_raster_column FROM raster_columns WHERE r_table_name = rastertable INTO rastcol;
raise notice 'raster column : %',rastcol;
	--Setting the tile_geom to tiles that are complete (using envelope is much faster) 
	strsql = concat('UPDATE ',rastertable,' 
					SET tile_geom = ST_Multi(ST_Setsrid(   ST_Envelope(',rastcol,') , st_srid(',rastcol,') )) 
					WHERE  st_height(',rastcol,') * st_width(',rastcol,') = (ST_SummaryStats(',rastcol,',1, TRUE )).count 
	 					AND resolution = ',resolution,'
						AND filename like ', quote_literal(filename||'%depth%'));
	raise notice 'Update full tiles: %', strsql;
 	EXECUTE strsql;
	raise notice 'Update full tiles done %', ':)';
	--Setting tile_geom to partial tiles
	strsql = concat('UPDATE ',rastertable,' 
					SET tile_geom =  ST_Multi(ST_Setsrid(  ST_Polygon(',rastcol,'), st_srid(',rastcol,') )) 
					WHERE  st_height(',rastcol,') * st_width(',rastcol,') != (ST_SummaryStats(',rastcol,',1, TRUE )).count 
	 					AND resolution = ',resolution,'
						AND filename like ',quote_literal(filename||'%depth%'));

	raise notice 'Update partiel tiles: %', strsql;
 	EXECUTE strsql;
	raise notice 'Update partiel tiles done %', ':)';
 
  exception when others then

      raise notice ' % ', SQLERRM;

END;

$BODY$;

CREATE OR REPLACE FUNCTION public.dfo_delete_empty_tiles(
	rastertable text,
	filename text)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$

	DECLARE
          rastcol text;
	  strsql text;
	BEGIN

	SELECT r_raster_column FROM raster_columns WHERE r_table_name = rastertable INTO rastcol;
	
	--Delete tiles containing nodata only
	strsql = concat('DELETE FROM ',rastertable, ' 
					WHERE (ST_SummaryStats ( ',rastcol,', 1, TRUE )).count =0
					AND filename LIKE ',quote_literal(filename||'%')); 	
	raise debug 'Delete nodata_tiles % ', strsql;
	EXECUTE strsql;

  exception when others then

      raise notice ' % ', SQLERRM;

END;

$BODY$;

CREATE OR REPLACE FUNCTION public.dfo_merge_bands(
	rastertable text,
	filename text)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$

	DECLARE
      rastcol text;
	  strsql text;
	  rastTypes text[] = array['mean','stddev','density'];
	  rastType text;
	BEGIN
	--Merging all bands to the "depth" tiles
	SELECT r_raster_column FROM raster_columns WHERE r_table_name = rastertable INTO rastcol; 
     
    FOREACH rastType IN ARRAY rastTypes
	LOOP
     
		--Add 'rastType' band to his corresponding depth tile 
		strsql = concat('UPDATE ',rastertable,' u SET ',rastcol,' = bnd from 
						(SELECT d.id, (ST_AddBand(d.',rastcol,' , o.',rastcol,' ,1)) as bnd
						 FROM ',rastertable,' d join  ',rastertable,' o ON
								ST_Equals(d.tile_extent,o.tile_extent) 
								AND d.filename LIKE ',quote_literal(filename||'%depth%'),' 
								AND o.filename  LIKE ',quote_literal(filename||'%'||rastType||'.tiff'),' 
								AND o.resolution=d.resolution) sr
						 WHERE sr.id=u.id');
    	raise notice '%  ',strsql;
		EXECUTE strsql;
		
		--delte  'rastType' band from table
		strsql = concat('DELETE FROM  ',rastertable,' WHERE filename  LIKE ',quote_literal(filename||'%'||rastType||'.tiff'));
		raise notice '%  ',strsql;
		EXECUTE strsql;
	END LOOP;

  exception when others then

      raise notice ' % ', SQLERRM;

END;

$BODY$;
-- FUNCTION: public.dfo_metadata(text, text)

-- DROP FUNCTION public.dfo_metadata(text, text);

CREATE OR REPLACE FUNCTION public.dfo_metadata(
	rastertable text,
	filename text)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$

	DECLARE
	  strsql text;
	BEGIN


	--Set metadata_id hack necessaire car le xml n'est pas gérer dans le code python. 
	-- on va chercher le objnam dans la table metadata qui n'a pas encore été affeté et on l'affecte au enregistrements en traitement.

 	strsql = concat('UPDATE ',rastertable, ' set metadata_id = (
				   	select objnam from ',rastertable,' RIGHT JOIN ',rastertable,'_metadata ON metadata_id=objnam
					where metadata_id is null
				   )
					WHERE filename LIKE ',quote_literal(filename||'%'));
	raise debug 'Update metadata_id: % ', strsql;
	EXECUTE strsql;

	--Set the tile sys_period from metadata
	strsql = concat('UPDATE ',rastertable,'
					SET sys_period = tstzrange( sursta::timestamp with time zone, null )
					FROM  ',rastertable,'_metadata   WHERE  objnam  = metadata_id
					AND filename LIKE ',quote_literal(filename||'%'));

	raise debug 'Update sys_period:  % ', strsql;				
	EXECUTE strsql;	

  exception when others then

      raise notice ' % ', SQLERRM;

END;

$BODY$;

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

