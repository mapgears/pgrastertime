-- FUNCTION: public.dfo_invalidate(text, text)

-- DROP FUNCTION public.dfo_invalidate(text, text);

CREATE OR REPLACE FUNCTION public.dfo_invalidate(
	rastertable text,
	manage_older text DEFAULT 'true'::text)
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
q:= array['16m','8m','4m','2m','1m','50cm','25cm'];

 query := concat( 'SELECT distinct objnam FROM ', rastertable,'_metadata') ;
 
 FOR sounding IN EXECUTE query  
 LOOP
		FOREACH resol  IN ARRAY q  --'{'16m','8m','4m','2m','1m','50cm','25cm'}' 
		LOOP
		    RAISE NOTICE '%', 'Resolution: ' || resol || ' / Metadata id:' || quote_literal(sounding.objnam);
			query := concat( 'SELECT dfo_invalidate_tiles2( ',quote_literal(sounding.objnam),',
															''soundings_',resol,''',',
															manage_older,')'); 
	         EXECUTE query; 
		END LOOP;
 END LOOP;
  
exception when others then
	raise exception ' % ', SQLERRM;

END;
$BODY$;

