-- FUNCTION: public.dfo_calculate_tile_extents(text, text)

DROP FUNCTION public.dfo_calculate_tile_extents(text, text);

CREATE OR REPLACE FUNCTION public.dfo_calculate_tile_extents(
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
	rtn text;
	tiles_extents integer;
BEGIN

	SELECT r_raster_column FROM raster_columns WHERE r_table_name = rastertable INTO rastcol;
	
	EXECUTE concat('SELECT count(*) FROM ',rastertable,
				   ' WHERE filename LIKE '
				   ,quote_literal(filename || '%')) INTO tiles_extents; 
	rtn := 'Update '|| tiles_extents ||' tile extents';	
	
	RAISE NOTICE '%', rtn;
	
	--Setting tile extent 
	strsql = concat('UPDATE ',rastertable,' 
					 SET tile_extent = ST_Setsrid(  ST_Envelope(',rastcol,'), st_srid(',rastcol,'))
					 WHERE filename like  ', quote_literal(filename||'%'));					
    RAISE DEBUG 'Update tile_extent with:  % ', strsql;
	EXECUTE strsql;
 
    RETURN rtn;
	
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE ' % ', SQLERRM;

END;
$BODY$;
