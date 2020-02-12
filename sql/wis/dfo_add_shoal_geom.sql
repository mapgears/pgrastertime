-- FUNCTION: public.dfo_add_shoal_geom(text, numeric, numeric, text)

DROP FUNCTION public.dfo_add_shoal_geom(text, numeric, numeric, text);

CREATE OR REPLACE FUNCTION public.dfo_add_shoal_geom(
	rastertable text,
	resolution numeric,
	shoal_limit numeric,
	filename text)
RETURNS text
LANGUAGE 'plpgsql'
COST 100
VOLATILE 
AS $BODY$

DECLARE
    state text;
	strsql text;
	rastcol text;
	shaol_geom_to_update integer;
	rtn text;
BEGIN

    --Find the raster column field name
    SELECT r_raster_column FROM raster_columns WHERE r_table_name = rastertable INTO rastcol;
    
	-- Delete temp table  ... 
    DROP TABLE IF EXISTS shoal_tmp;
	
	-- 
    strsql = concat( 'CREATE TEMPORARY TABLE shoal_tmp AS SELECT id, 
              ST_Reclass(st_band(',rastcol,',4), 1, ''-20-',shoal_limit,'):''|| 
		      ST_BandNoDataValue( ',rastcol,',1)||'', [',shoal_limit,'-15:1'', ''4BUI'',
		      ST_BandNoDataValue( ',rastcol,',1)  )
         FROM ',rastertable,' 
         WHERE filename LIKE ', quote_literal(filename||'%depth%'),'
         AND resolution =', resolution);
    RAISE DEBUG 'Creating temp table for uptate with : %', strsql;
	
    EXECUTE concat('SELECT count(*) FROM ',rastertable,' WHERE filename LIKE ', 
                quote_literal(filename||'%depth%'),
				'AND resolution =', resolution ) INTO shaol_geom_to_update; 
    rtn := 'Run update query for '|| shaol_geom_to_update || ' geometries...';
	RAISE NOTICE '%', rtn;
    
	EXECUTE strsql;

    -- Update Shoal Geom based on temp table.
    strsql = format('UPDATE %s p 
                SET shoal_geom = ST_Polygon(ST_Band(st_reclass,5))
				FROM shoal_tmp s
			    WHERE p.id=s.id',rastertable);
    RAISE DEBUG 'Update Shoal Geom with : %', strsql;
	EXECUTE strsql;
	
	RETURN rtn;
	
	EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE ' % ', SQLERRM;

END;
$BODY$;