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
