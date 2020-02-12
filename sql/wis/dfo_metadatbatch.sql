-- FUNCTION: public.dfo_metadatbatch(text)

-- DROP FUNCTION public.dfo_metadatbatch(text);

CREATE OR REPLACE FUNCTION public.dfo_metadatbatch(
	rastertable text)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$

DECLARE
	query TEXT;
	sounding RECORD;
	n integer;
	 resol text  ;
	 q text[];
	 
BEGIN 
 query := concat( 'SELECT distinct objnam FROM ', rastertable,'_metadata') ;
 FOR sounding IN EXECUTE query  
        LOOP
      query = concat('select dfo_metadata(',quote_literal(rastertable),',',quote_literal(lower(sounding.objnam)),')');
 	  execute query;
 END LOOP;
           
  
exception when others then
	raise exception ' % ', SQLERRM;

END;

$BODY$;

