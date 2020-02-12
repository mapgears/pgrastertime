-- FUNCTION: public.dfo_add_conformance_band(text, text, text, numeric, text)

DROP FUNCTION public.dfo_add_conformance_band(text, text, text, numeric, text);

CREATE OR REPLACE FUNCTION public.dfo_add_conformance_band(
	rastertable text,
	sectortable text,
	sectorgeom text,
	resolution numeric,
	filename text)
RETURNS text
LANGUAGE 'plpgsql'
COST 100
VOLATILE 
AS $BODY$

DECLARE
	state text;
	nbands integer;
	rastcol text;
	strsql text;
	rtn text;
	nb_rows integer;
	i integer;
BEGIN

    --get the raster column name from catalog
    SELECT r_raster_column FROM raster_columns WHERE r_table_name = rastertable INTO rastcol;
    nb_rows := 0;
	
    -- Create a temporary table being the clip of the raster on his intersecting geometries 
	-- of the sector table (containing the disign grade) for a particular resolution and filename.
    strsql := concat( 'DROP TABLE IF EXISTS tmp_clip_to_conformance; 
                      CREATE TEMPORARY TABLE tmp_clip_to_conformance AS 
                      SELECT r.id,ST_Clip(',rastcol,',  ',sectorgeom,' ,false) AS raster , maintained 
                      FROM ' ,rasterTable,' r JOIN ',sectorTable,' s ON ST_Intersects(tile_extent , ',sectorgeom,')
                      WHERE filename LIKE ' , quote_literal(filename||'%'), ' AND resolution = ',resolution);
    EXECUTE strsql;
	EXECUTE 'SELECT count(*) FROM tmp_clip_to_conformance' INTO nb_rows;
	RAISE DEBUG 'Creat tmp table for sector table in %', strsql;

    --create a second temporary table calculating the "conformance" by map algebra. 
    DROP TABLE IF EXISTS tmp_conformance_algebra;			 
    CREATE TEMPORARY TABLE tmp_conformance_algebra AS 
	SELECT id, ST_MapAlgebra(raster, 1, NULL, concat(maintained,'+[rast.val]')) AS raster 
    FROM tmp_clip_to_conformance;

    --create a third temporary table containing the union of all potentiel part of the same tile
    --having clipped on several design grade.
    DROP TABLE IF EXISTS tmp_conformance;
    CREATE TEMPORARY TABLE tmp_conformance AS 				  
    SELECT id, ST_Union(raster) AS raster FROM tmp_conformance_algebra GROUP BY id;

    --Update the original raster by adding the band genarated in the tmp_conformance table. 
    strsql := concat('UPDATE ',rasterTable,' o 
			          SET ',rastcol,' =  ST_AddBand(o.',rastcol,', co.raster , 1)
			          FROM tmp_conformance co WHERE co.id=o.id');		
    EXECUTE strsql;		

    -- Add un null 'conformance' band for tile that are not intersecting any zone 
	-- (possible for soundings witch excede the chanel or zones without design grades) 
    strsql = concat ('UPDATE ',rasterTable, 
                     ' SET ',rastcol,' = ST_AddBand(',rastcol,', --destination raster.
                                        ST_BandPixelType(',rastcol,',1), --pixel type
                                        ST_BandNoDataValue(',rastcol,',1), -- assign nodata value to all pixels
                                        ST_BandNoDataValue(',rastcol,',1)) -- assign nodata value to raster 
				      WHERE filename LIKE ' , quote_literal(filename||'%'), ' 
				      AND resolution = ',resolution, ' AND ST_Numbands(',rastcol,')=3');
    RAISE DEBUG 'Update Band with: %', strsql;	
	EXECUTE strsql;

    RETURN 'Update conformance band for ' || nb_rows || ' rows.';
	
    EXCEPTION WHEN OTHERS THEN
	    RAISE EXCEPTION' % ', SQLERRM;

END;
$BODY$;

