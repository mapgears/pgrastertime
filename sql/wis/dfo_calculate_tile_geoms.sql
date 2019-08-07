
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
