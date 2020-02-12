-- FUNCTION: public.dfo_sounding_age(integer)

-- DROP FUNCTION public.dfo_sounding_age(integer);

CREATE OR REPLACE FUNCTION public.dfo_sounding_age(
	in_year integer)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE STRICT 
AS $BODY$
DECLARE
	max_year integer; 
BEGIN

--create a temporary table that contains the surface of soundings of the given year
DROP TABLE IF EXISTS data_age_year_clipped;
CREATE TEMPORARY TABLE data_age_year_clipped AS 
	SELECT year,geom 
	FROM sounding_age_year where year = in_year ;

SELECT max(year)  FROM sounding_age_year INTO max_year; --get the max year of the table
IF in_year<max_year THEN  --if input year is lower than max year.
	--Create a temporary table that contains the union of the soundings of the years greater than the input year
	DROP TABLE IF EXISTS newer;					  
	create temporary table newer as select st_union(geom) as newer_soundings
	 from  sounding_age_year where year > in_year;
	--Update the geometry by the difference between current year extent and folowing years  extents
	UPDATE data_age_year_clipped SET geom =  (SELECT   st_difference( geom, newer_soundings ) 
											  FROM data_age_year_clipped JOIN newer on true);
END IF;

DELETE FROM  sounding_age WHERE year = in_year;
INSERT INTO sounding_age SELECT year,(st_dump(geom)).geom FROM data_age_year_clipped;
			  
END;
$BODY$;

