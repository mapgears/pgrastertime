-- FUNCTION: public.dfo_invalidate(text, text, text)

-- DROP FUNCTION public.dfo_invalidate(text, text, text);

CREATE OR REPLACE FUNCTION public.dfo_invalidate(
	schema_ text,
	rastertable text,
	manage_older text DEFAULT 'true'::text,
	hight_resolution text DEFAULT 'true'::text)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$

DECLARE
    query_ TEXT;
    sounding RECORD;
    resol text  ;
    q text[];
    count_rows integer;
	counter_ text;
	i integer;
BEGIN
-- TODO, find a new way to invalidate tiles for 2m, 1m, 50cm and 25cm.  The actual method is too slow.  
-- the dfo_invalidate_tiles contains 3 queries that never respond.  Needs deeper analysis to find why.
-- By removing those resolution, we bypass the problem for now.
-- q:= array['16m','8m','4m','2m','1m','50cm','25cm'];
IF hight_resolution THEN 
    q:= array['16m','8m','4m','2m','1m']; 
ELSE
    q:= array['16m','8m','4m'];
END IF;

i := 0;
EXECUTE concat('SELECT count(DISTINCT objnam) FROM ', schema_, '.',rastertable,'_metadata') INTO count_rows; 

query_ := concat( 'SELECT DISTINCT objnam FROM ', schema_, '.', rastertable,'_metadata') ;
 
FOR sounding IN EXECUTE query_  
LOOP
    i = i + 1;
		FOREACH resol  IN ARRAY q  --'{'16m','8m','4m','2m','1m'}' 
		LOOP
		    counter_ := '(' || i || ' of ' || count_rows || ' objnam)';

		    RAISE NOTICE '%', '=============== Resolution: ' || resol || ' / Metadata id:' || 
			                   quote_literal(sounding.objnam) || ' ' || quote_literal(counter_) ;
							   
			query_ := concat( 'SELECT dfo_invalidate_tiles( ',quote_literal(sounding.objnam),
															',''', schema_, '.soundings_',resol,''',',
															manage_older,',',quote_literal(counter_),')'); 

	        EXECUTE query_;
			
		END LOOP;
END LOOP;
  
EXCEPTION WHEN OTHERS THEN
    RAISE EXCEPTION' % ', SQLERRM;

END;
$BODY$;

ALTER FUNCTION public.dfo_invalidate(text, text, text)
    OWNER TO pgrastertime;
