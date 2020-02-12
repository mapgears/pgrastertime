-- FUNCTION: public.dfo_split2(geometry[], text)

-- DROP FUNCTION public.dfo_split2(geometry[], text);

CREATE OR REPLACE FUNCTION public.dfo_split2(
	in_geom geometry[],
	table_out text)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE STRICT 
AS $BODY$
DECLARE
n integer;
sql_poly text;
geo geometry;
i integer;
begin
DROP TABLE IF EXISTS tmp_poly;
DROP TABLE IF EXISTS tmp_poly_result;

--sql_poly:= concat(' CREATE TEMPORARY TABLE tmp_poly as select (st_dump(''',in_geom,''')).geom::geometry as geom');
--EXECUTE sql_poly;	

CREATE TABLE public.tmp_poly_result
(
	id serial not null,
    geom geometry
);
i:=0;
 FOREACH geo    IN ARRAY in_geom
   LOOP
i:=i+1; 
SELECT st_area(geo) / 500000  INTO n;
raise notice 'element % divise en % ' , i ,n ;
 

if n>0 THEN 
raise notice 'resplit';
DROP TABLE IF EXISTS poly_pts;
DROP TABLE IF EXISTS poly_pts_clustered;
DROP TABLE IF EXISTS poly_centers;
DROP TABLE IF EXISTS poly_voronoi;
DROP TABLE IF EXISTS poly_divided;

	-- see http://blog.cleverelephant.ca/2018/06/polygon-splitting.html for exlanation of splitting method
	-- Splitting polygons of about 250000 m2 of area 
	 CREATE TEMPORARY TABLE poly_pts AS
 					  SELECT (ST_Dump(ST_GeneratePoints(geo, 2000))).geom AS geom ;

	sql_poly:= concat('CREATE TEMPORARY TABLE poly_pts_clustered AS
						SELECT geom, ST_ClusterKMeans(geom,',n,') over () AS cluster
						FROM poly_pts');

	EXECUTE sql_poly;	 				
	CREATE TEMPORARY TABLE poly_centers AS					 
	SELECT cluster, ST_Centroid(ST_collect(geom)) AS geom
	FROM poly_pts_clustered
	GROUP BY cluster;		

	CREATE TEMPORARY TABLE poly_voronoi AS
	  SELECT (ST_Dump(ST_VoronoiPolygons(ST_collect(geom)))).geom AS geom
	  FROM poly_centers;
													
	
	CREATE TEMPORARY TABLE poly_divided AS
	  SELECT ST_Intersection(a.geo, b.geom) AS geom
	  FROM (SELECT geo ) a
	  CROSS JOIN poly_voronoi b;
	 
else
	  raise notice 'spit pas';
END IF;

INSERT INTO  tmp_poly_result(geom) select geom from poly_divided;

end loop;
END;
$BODY$;

ALTER FUNCTION public.dfo_split2(geometry[], text)
    OWNER TO stecyr;
