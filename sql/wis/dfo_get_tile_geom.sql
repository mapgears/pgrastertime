-- FUNCTION: public.dfo_get_tile_geom(raster)
DROP FUNCTION public.dfo_get_tile_geom(raster);

CREATE OR REPLACE FUNCTION public.dfo_get_tile_geom(
	rastercol raster)
    RETURNS geometry
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$

	DECLARE
      x geometry;
	 bln_complete boolean;
	BEGIN
	SELECT st_height(rastercol) * st_width(rastercol) = ((ST_SummaryStats(rastercol,1, TRUE )).count)   into bln_complete;
 	raise notice 'complete : %', bln_complete;
	if bln_complete THEN	
	--Setting the tile_geom to tiles that are complete (using envelope is much faster) 
	SELECT ST_Multi(ST_Setsrid(   ST_Envelope(rastercol) , st_srid(rastercol) )) INTO x;
	ELSE --Setting tile_geom to partial tiles 						
	SELECT  ST_Multi(ST_Setsrid(  ST_Polygon(rastercol), st_srid(rastercol) )) INTO x;
	END IF;
	return x;
								
  exception when others then

      raise notice ' % ', SQLERRM;

END;

$BODY$;

