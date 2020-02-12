-- FUNCTION: public.dfo_delete_empty_tiles(text, text)

DROP FUNCTION public.dfo_delete_empty_tiles(text, text);

CREATE OR REPLACE FUNCTION public.dfo_delete_empty_tiles(
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
	notdata_tiles_to_delete integer;
	rtn text;
BEGIN

	SELECT r_raster_column FROM raster_columns WHERE r_table_name = rastertable INTO rastcol;
	
	EXECUTE concat('SELECT count(*) FROM ',rastertable,
				   ' WHERE (ST_SummaryStats ( ',rastcol,
				   ', 1, TRUE )).count =0 AND filename LIKE '
				   ,quote_literal(filename || '%')) INTO notdata_tiles_to_delete; 
	rtn := 'Delete '||notdata_tiles_to_delete ||' nodata tile';			   
	RAISE NOTICE '%', rtn;
	
	--Delete tiles containing nodata only
	strsql = concat('DELETE FROM ',rastertable, ' 
					WHERE (ST_SummaryStats ( ',rastcol,', 1, TRUE )).count =0
					AND filename LIKE ',quote_literal(filename||'%')); 	
	RAISE DEBUG 'Delete tiles containing nodata with:  % ', strsql;
	EXECUTE strsql;

    RETURN rtn;
	
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE ' % ', SQLERRM;

END;
$BODY$;


