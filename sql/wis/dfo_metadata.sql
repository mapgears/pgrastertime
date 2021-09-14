-- FUNCTION: public.dfo_metadata(text, text)

DROP FUNCTION IF EXISTS public.dfo_metadata(text, text);

CREATE OR REPLACE FUNCTION public.dfo_metadata(
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
	  met_id text;
	  rec record;
	BEGIN

	SELECT r_raster_column FROM raster_columns WHERE r_table_name = rastertable INTO rastcol;
	
	raise debug '1';
	-- affecte le objnam au metadata_id  		
	strsql = concat('UPDATE  ',rastertable, ' SET metadata_id = objnam
 					 FROM ',rastertable,'_metadata WHERE filename LIKE concat(lower(objnam),''%'')
	 				  AND filename LIKE ',quote_literal(filename||'%'));
 
	raise debug 'Update metadata_id: % ', strsql;

EXECUTE strsql;
	
--obtaining the metadata_id affected to new records
strsql = concat ('SELECT metadata_id FROM ',rastertable,' WHERE  filename LIKE lower(',quote_literal(filename||'%'),')');

raise debug 'get metadata_id : %', strsql;
EXECUTE strsql INTO met_id;

--get values of surend and cretim 
strsql = concat ('SELECT surend,cretim 
				 FROM ',rastertable,'_metadata 
				 WHERE  objnam = ',quote_literal( met_id ) ) ;
raise debug 'get date:  %', strsql;
EXECUTE strsql into rec;
  
--Set the tile sys_period from metadata
IF rec.surend is not null THEN 
	strsql = concat('UPDATE ',rastertable,'
					SET sys_period = tstzrange( surend::timestamp with time zone, null )
					FROM  ',rastertable,'_metadata   WHERE  objnam  = metadata_id
					AND filename LIKE ',quote_literal(filename||'%'));
ELSE 
strsql = concat('UPDATE ',rastertable,'
					SET sys_period = tstzrange( cretim::timestamp with time zone, null )
					FROM  ',rastertable,'_metadata   WHERE  objnam  = metadata_id
					AND filename LIKE ',quote_literal(filename||'%'));

END IF;
	raise debug 'Update sys_period:  % ', strsql;				
	EXECUTE strsql;	
 
  exception when others then

      raise notice ' % ', SQLERRM;

END;
$BODY$;



