-- FUNCTION: public.dfo_calculate_tile_geoms(text, numeric, text)

DROP FUNCTION public.dfo_calculate_tile_geoms(text, numeric, text);

CREATE OR REPLACE FUNCTION public.dfo_calculate_tile_geoms(
	rastertable text,
	resolution numeric,
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
	geom_to_update integer;
BEGIN

	SELECT r_raster_column FROM raster_columns WHERE r_table_name = rastertable INTO rastcol;
	
	EXECUTE concat('SELECT count(*) FROM ',rastertable,' WHERE resolution =',
				   resolution,' AND filename LIKE ', 
				   quote_literal(filename||'%')) INTO geom_to_update; 

     rtn := 'Update '|| geom_to_update ||' tile geom';
	
	RAISE NOTICE '%', rtn;
	
	--Setting the tile_geom to tiles that are complete (using envelope is much faster) 
	strsql = concat('UPDATE ',rastertable,' 
					SET tile_geom = ST_Multi(ST_Setsrid(   ST_Envelope(',rastcol,') , st_srid(',rastcol,') )) 
					WHERE  st_height(',rastcol,') * st_width(',rastcol,') = (ST_SummaryStats(',rastcol,',1, TRUE )).count 
	 				AND resolution = ',resolution,'
					AND filename like ', quote_literal(filename||'%depth%'));
    RAISE DEBUG 'Update complete tile_geom with:  % ', strsql;	
    EXECUTE strsql;
	
	--Setting tile_geom to partial tiles 						
	strsql = concat('UPDATE ',rastertable,' 
					SET tile_geom =  ST_Multi(ST_Setsrid(  ST_Polygon(',rastcol,'), st_srid(',rastcol,') )) 
					WHERE  st_height(',rastcol,') * st_width(',rastcol,') != (ST_SummaryStats(',rastcol,',1, TRUE )).count 
	 				AND resolution = ',resolution,'
					AND filename like ',quote_literal(filename||'%depth%'));
    RAISE DEBUG 'Update partial tile_geom with:  % ', strsql;	
    EXECUTE strsql;

    RETURN rtn;
	
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE ' % ', SQLERRM;
END;
$BODY$;
