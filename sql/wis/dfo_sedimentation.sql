-- FUNCTION: public.dfo_sedimentation(text, text, geometry, text, numeric, text)

DROP FUNCTION public.dfo_sedimentation(text, text, geometry, text, numeric, text);

CREATE OR REPLACE FUNCTION public.dfo_sedimentation(
	date_ori text,
	date_dest text,
	in_geom geometry,
	tablename text,
	resolution numeric,
	table_out text)
    RETURNS text
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE STRICT 
AS $BODY$
DECLARE
	--rec RECORD;
	--rec1 RECORD;
	sql_final text;
    sql_dest text;
	sql_poly text;
	sql_ori text;
	n integer;
	 blnstop boolean;
BEGIN 

SELECT table_out  not like 'sedim_%' INTO blnstop;
if blnstop IS false then 

sql_poly:= concat('DROP TABLE IF EXISTS poly;
					 DROP TABLE IF EXISTS poly_pts;
					 DROP TABLE IF EXISTS poly_pts_clustered;
					 DROP TABLE IF EXISTS poly_centers;
					 DROP TABLE IF EXISTS poly_voronoi;
					 DROP TABLE IF EXISTS poly_divided;
					 CREATE TEMPORARY TABLE poly as select ''',in_geom,'''::geometry as geom');
					 EXECUTE sql_poly;	
					 
SELECT st_area(geom) / 250000 from poly INTO n;

if n>0 THEN 
	-- see http://blog.cleverelephant.ca/2018/06/polygon-splitting.html for exlanation of splitting method
	-- Splitting polygons of about 250000 m2 of area 
	sql_poly:= concat('CREATE TEMPORARY TABLE poly_pts AS
 					  SELECT (ST_Dump(ST_GeneratePoints(geom, 2000))).geom AS geom FROM poly');
					  
	EXECUTE sql_poly;	 

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
													
	DROP TABLE poly;
	CREATE TEMPORARY TABLE poly_divided AS
	  SELECT ST_Intersection(a.geom, b.geom) AS geom
	  FROM poly a
	  CROSS JOIN poly_voronoi b;
	  ALTER TABLE poly_divided add column id serial not null;
	  ALTER TABLE poly_divided RENAME TO poly;
END IF;
--generate the depth raster at destination date  													
sql_dest:= concat( 'DROP TABLE IF EXISTS  sedimentation_depth_destination;
CREATE TEMPORARY TABLE   sedimentation_depth_destination as 
WITH  dataset AS (
SELECT 1 as id, ST_Union(rast ORDER BY lower(sys_period))  rast 
FROM ',tablename,' JOIN poly ON ST_Intersects(tile_geom ,st_transform(geom,st_srid(tile_geom))) 
WHERE resolution=',resolution,'
and sys_period=',quote_literal(date_dest),'
and lower  (sys_period ) >',quote_literal(date_ori),'
GROUP BY  1
)
SELECT id,ST_Clip (rast,  st_transform(''',in_geom,'''::geometry,st_srid(rast)) ) rast FROM dataset');

--generate the depth raster at origin date  										 
sql_ori:= concat('DROP TABLE IF EXISTS sedimentation_depth_origin;
CREATE TEMPORARY TABLE  sedimentation_depth_origin as 
WITH  dataset AS (
SELECT 1 as id, ST_Union(rast ORDER BY lower(sys_period))  rast 
FROM ',tablename,' JOIN poly ON ST_Intersects(tile_geom ,st_transform(geom,st_srid(tile_geom)))   
WHERE resolution=',resolution,'
and sys_period=',quote_literal(date_ori),'
GROUP BY  1
)
SELECT id,ST_Clip (rast,  st_transform(''',in_geom,'''::geometry,st_srid(rast)) ) rast FROM dataset');
raise notice '%',sql_dest;
EXECUTE sql_dest;
EXECUTE sql_ori;
 								
--substrac origin depth to destination depth by  Map algebra to get the sedimentation
sql_final:= concat('DROP  TABLE IF EXISTS ',table_out,';
CREATE TABLE ',table_out,' as
SELECT ((ST_MapAlgebra( d.rast, 1,o.rast , 1,''[rast1.val]-[rast2.val]''))) as rast
FROM   sedimentation_depth_destination d join sedimentation_depth_origin o on o.id=d.id;
select AddRasterConstraints( ',quote_literal(table_out),',''rast'')  ');
EXECUTE sql_final;
else 
	raise exception 'Tablename must begin with sedim_' ;
end if;
return 'OK';
END;
$BODY$;

