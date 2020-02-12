-- FUNCTION: public.dfo_get_conformance_band(raster, text, text)

-- DROP FUNCTION public.dfo_get_conformance_band(raster, text, text);

CREATE OR REPLACE FUNCTION public.dfo_get_conformance_band(
	in_raster raster,
	tablename text,
	geom text)
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

strsql:= concat( 'drop  table  if exists tmp_clip_to_conformance;
create temporary table tmp_clip_to_conformance as
select id,st_clip(',in_raster,',  ',geom,' ,false) as raster ,  , gid   
from ' ,rasterTable,'  JOIN ',sectorTable,' s ON st_intersects(tile_extent , ',sectorgeom,')
WHERE filename like ' , quote_literal(filename||'%'), ' AND resolution = ',resolution);
raise notice '%',strsql;

 drop  table if exists tmp_conformance_algebra;			 
	create temporary table tmp_conformance_algebra as select 
	id, ST_MapAlgebra(raster, 1, NULL, concat(maintained,'+[rast.val]')) as raster 
	FROM tmp_clip_to_conformance;
	drop  table if exists tmp_conformance;
	create temporary table tmp_conformance as 				  
	select id, st_union(raster) as raster from tmp_conformance_algebra group by id ;

strsql := concat('update ',rasterTable,' o 
			set ',rastcol,' =  ST_AddBand(o.',rastcol,', co.raster , 1)
			from tmp_conformance co where  co.id=o.id');		
EXECUTE strsql;		

--add un null 'conformance' band for tile that are not intersecting any zone 
 strsql = concat ('UPDATE ',rasterTable,'
                  SET ',rastcol,' = ST_AddBand(',rastcol,', --destination raster.
                                        ST_BandPixelType(',rastcol,',1), --pixel type
                                        ST_BandNoDataValue(',rastcol,',1), -- assign nodata value to all pixels
                                        ST_BandNoDataValue(',rastcol,',1)) -- assign nodata value to raster 
				  WHERE filename like ' , quote_literal(filename||'%'), ' 
				  AND resolution = ',resolution, ' 
				  AND st_numbands(',rastcol,')=4');
	EXECUTE strsql;
										  
raise notice 'Update Band: %', strsql;			  

  exception when others then

      raise notice ' % ', SQLERRM;

END;

$BODY$;

