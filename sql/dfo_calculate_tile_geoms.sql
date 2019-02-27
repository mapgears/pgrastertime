-- FUNCTION: public.dfo_calculate_tile_geoms(text, numeric)

-- DROP FUNCTION public.dfo_calculate_tile_geoms(text, numeric);

CREATE OR REPLACE FUNCTION public.dfo_calculate_tile_geoms(
	rastertable text,
	resolution numeric)
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
	
	--Setting the tile_geom to tiles that are complete (using envelope is much faster) 
	strsql = concat('UPDATE ',rastertable,' 
					SET tile_geom = ST_Multi(ST_Setsrid(   ST_Envelope(',rastcol,') , st_srid(',rastcol,') )) 
					WHERE  st_height(',rastcol,') * st_width(',rastcol,') = (ST_SummaryStats(',rastcol,',1, TRUE )).count 
	 					AND resolution = ',resolution,'
						AND filename like ''%depth.tiff''');
	raise debug 'Update full tiles: %', strsql;
 	EXECUTE strsql;
	
	--Setting tile_geom to partial tiles 						
	strsql = concat('UPDATE ',rastertable,' 
					SET tile_geom =  ST_Multi(ST_Setsrid(  ST_Polygon(',rastcol,'), st_srid(',rastcol,') )) 
					WHERE  st_height(',rastcol,') * st_width(',rastcol,') != (ST_SummaryStats(',rastcol,',1, TRUE )).count 
	 					AND resolution = ',resolution,'
						AND filename like ''%depth.tiff''');
						
	raise debug 'Update partiel tiles: %', strsql;
 	EXECUTE strsql;
	
  exception when others then

      raise notice ' % ', SQLERRM;

END;

$BODY$;

