-- FUNCTION: public.dfo_metadata(text)

-- DROP FUNCTION public.dfo_metadata(text);

CREATE OR REPLACE FUNCTION public.dfo_metadata(
	rastertable text)
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
					WHERE (ST_SummaryStats ( ',rastcol,', 1, TRUE )).count =0'); 	
	raise debug 'Delete nodata_tiles % ', strsql;
	EXECUTE strsql;
	
	--Set metadata_id 
 	strsql = concat('UPDATE ',rastertable, ' set metadata_id = (select objnam from xml_tmp)');
	raise debug 'Update metadata_id: % ', strsql;
	EXECUTE strsql;
	
	--Set the tile sys_period from metadata
	strsql = concat('UPDATE ',rastertable,'
					SET sys_period = tstzrange( surend::timestamp with time zone, null )
					FROM  metadata   WHERE  objnam  = metadata_id');
	raise debug 'Update sys_period:  % ', strsql;				
	EXECUTE strsql;	
 
  exception when others then

      raise notice ' % ', SQLERRM;

END;

$BODY$;
 