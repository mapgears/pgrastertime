
CREATE OR REPLACE FUNCTION public.dfo_delete_empty_tiles_(
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
	
	--Delete tiles containing nodata only
	strsql = concat('DELETE FROM ',rastertable, ' 
					WHERE (ST_SummaryStats ( ',rastcol,', 1, TRUE )).count =0
					AND filename LIKE ',quote_literal(filename||'%')); 	
	raise debug 'Delete nodata_tiles % ', strsql;
	EXECUTE strsql;

  exception when others then

      raise notice ' % ', SQLERRM;

END;

$BODY$;

