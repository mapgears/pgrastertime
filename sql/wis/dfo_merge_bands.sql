-- FUNCTION: public.dfo_merge_bands(text, text)

DROP FUNCTION public.dfo_merge_bands(text, text);

CREATE OR REPLACE FUNCTION public.dfo_merge_bands(
	rastertable text,
	filename text)
RETURNS text
LANGUAGE 'plpgsql'
COST 100
VOLATILE 
AS $BODY$

DECLARE
    rastcol text;
    strsql text;
    rastTypes text[] = array['mean','stddev','density'];
    rastType text;
	rtn text;
	msg text;
	deleted_rows integer;
	i integer;
BEGIN
    
	--Get raster field name
	SELECT r_raster_column FROM raster_columns WHERE r_table_name = rastertable INTO rastcol; 
    deleted_rows = 0;
	--Merging all bands to the "depth" tiles
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
		msg := 'Add band '|| rastType || ' in raster column with :'|| strsql;
    	RAISE DEBUG '%', msg;
		
		EXECUTE strsql;
		
		-- log for output to user...
		strsql = concat('SELECT count(*) FROM  ',rastertable,' WHERE filename  LIKE ',quote_literal(filename||'%'||rastType||'.tiff'));
		RAISE DEBUG 'Log %', strsql;
		EXECUTE strsql INTO i;
		deleted_rows := i + deleted_rows;
		
		--delte  'rastType' band from table
		strsql = concat('DELETE FROM  ',rastertable,' WHERE filename  LIKE ',quote_literal(filename||'%'||rastType||'.tiff'));
		msg := 'Delete rows of '|| rastType || ' in '|| rastertable || 'table  with :'|| strsql;
    	RAISE DEBUG '%', msg;
		
		EXECUTE strsql;

	END LOOP;
	
	rtn := 'Delete total of ' || deleted_rows || ' rows from ' || rastertable || ' table, merged into band in raster field.';
    RETURN rtn;
	
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE ' % ', SQLERRM;

END;
$BODY$;

