
CREATE OR REPLACE FUNCTION public.dfo_calculate_tile_extents(
	rastertable text,
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

	--Setting tile extent 
	strsql = concat('UPDATE ',rastertable,' 
					 SET tile_extent = ST_Setsrid(  ST_Envelope(',rastcol,'), st_srid(',rastcol,'))
					 WHERE filename like  ', quote_literal(filename||'%'));

	 raise debug 'Update extent : % ', strsql;
	 EXECUTE strsql;

  exception when others then

      raise notice ' % ', SQLERRM;

END;

$BODY$;
