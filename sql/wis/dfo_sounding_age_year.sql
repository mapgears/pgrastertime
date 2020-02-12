-- FUNCTION: public.dfo_sounding_age_year(integer)

-- DROP FUNCTION public.dfo_sounding_age_year(integer);

CREATE OR REPLACE FUNCTION public.dfo_sounding_age_year(
	in_year integer)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE STRICT 
AS $BODY$
DECLARE
	query  text;
BEGIN
	
	
DELETE FROM  sounding_age_year WHERE year = in_year;
INSERT INTO  sounding_age_year(geom,year)
	SELECT st_union (rast_geom )::geometry(multipolygon,3979) as geom ,
			extract(year from creatim)   
	FROM sounding_surface_s where extract(year from creatim)=in_year
	GROUP BY extract(year from creatim);
	 
    
END;
$BODY$;

