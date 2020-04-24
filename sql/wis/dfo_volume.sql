-- FUNCTION: public.dfo_volume(text, text, text)

DROP FUNCTION public.dfo_volume(text, text, text);

CREATE OR REPLACE FUNCTION public.dfo_volume(
	in_tablename text,
	in_sounding text,
	in_gabarit text)
    RETURNS text
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE STRICT 
AS $BODY$
DECLARE
	sql_sub_dataset text;
BEGIN 

--create a table with the sounding data on witch the volume should be calculated.
sql_sub_dataset:=concat('DROP TABLE IF EXISTS volume_template;
CREATE TEMPORARY TABLE volume_template as 
SELECT * 
FROM ',in_tablename,' 
WHERE metadata_id = ',quote_literal(in_sounding));
EXECUTE sql_sub_dataset;

--Clip the raster subset on the template geometries
DROP TABLE IF EXISTS volume_clip_to_template;																		  
CREATE TEMPORARY TABLE volume_clip_to_template as 
SELECT v.id,st_clip(raster  ,st_transform(geom_s,3979)),dredging_depth , d.id as drag_id 
FROM volume_template v 
     JOIN gabarit_dragage d ON st_intersects( tile_geom, st_transform(geom_s,3979) )
WHERE dredging_id = in_gabarit;
 
--using map algebra to create a 'height' raster having the difference between the desired  dredging depth and  'mean' depth.
--the mean is negative values so    positive values of (dredging_depth,'+[rast.val]') are representing volume above the desired dredging depth. 
DROP TABLE IF EXISTS volume_heitht_from_dredging_depth;
CREATE TABLE volume_heitht_from_dredging_depth as SELECT 
id,dredging_depth, drag_id,ST_MapAlgebra(st_clip, 2, NULL, concat(dredging_depth,'+[rast.val]')) as raster 
FROM volume_clip_to_template;

--create a raster of volume for each pixel  resol*resol* H
DROP TABLE IF EXISTS volume_tmp;
CREATE TABLE volume_tmp as SELECT 
id,dredging_depth,drag_id ,ST_MapAlgebra(raster,1, NULL, concat( st_scalex(raster )* st_scalex(raster ) ,'*[rast.val]')) as raster 
FROM volume_heitht_from_dredging_depth; 
 
--reclass pixels above and below dredging depth.
--below		
	/*create a temporary table with a reclass operation that creates 
	    1 for pixel lower than 0 
		and nodata for pixel greater than  0  */
	DROP TABLE IF EXISTS below_dredging_depth;
	CREATE TABLE below_dredging_depth
	AS SELECT id, 
			dredging_depth,
			drag_id,  
			ST_Reclass(raster,1,concat ('-100-0:1, 0-50:',ST_BandNoDataValue(raster) ), '4BUI',ST_BandNoDataValue(raster) )
	FROM volume_heitht_from_dredging_depth;
																
	--create the surface using st_polygon of the reclassed image.
	DROP TABLE IF EXISTS volume_dredging_depth_surface;	 
	CREATE TEMPORARY TABLE volume_dredging_depth_surface AS
	SELECT id,dredging_depth,drag_id,st_polygon(ST_Reclass), 'below dredging depth'	as typ 
	FROM below_dredging_depth;

--over		
	/*create a temporary table with a reclass operation that creates 
	    nodata for pixel lower than 0 
		and 1 for pixel greater than  0  */
	DROP TABLE IF EXISTS over_dredging_depth;
	CREATE TABLE over_dredging_depth
	AS SELECT id, 
				dredging_depth, 
				drag_id,  
				ST_Reclass(raster,1,concat ('-100-0:',ST_BandNoDataValue(raster),', 0-50:1' ), '4BUI',ST_BandNoDataValue(raster) )
	FROM volume_heitht_from_dredging_depth;	
																
	--create the surface using st_polygon of the reclassed image.
	INSERT INTO  volume_dredging_depth_surface  
	SELECT id,dredging_depth, drag_id, st_polygon(ST_Reclass), 'over dredging depth'	
	FROM over_dredging_depth;

/*
To be validated...should we also use the pixels witch are 0.2m lower than the desired dredging depth to determine the 'over dredging depth' area.
  ST_Reclass(raster,1,concat ('-100--0.2:',ST_BandNoDataValue(raster),', -0.2-0:1' ), '4BUI',ST_BandNoDataValue(raster) )
*/

--create a temporary table by cliping the volume raster on the surfaces (below and over dredging_depth)   
DROP TABLE IF EXISTS volume_surface;
CREATE TEMPORARY TABLE volume_surface as SELECT 
z.id,z.dredging_depth ,z.drag_id,typ,
st_clip(raster,st_polygon) as raster,st_polygon 						 
FROM   volume_tmp ra join volume_dredging_depth_surface z on z.id=ra.id and z.dredging_depth=ra.dredging_depth;

/*create a temporary vol_result_tmp  with the total area_to_dredge, the sum of pixel for volume_to_dredge
	and  the  'number of pixels' * resolution * resolution * alowance for overdredged_volume
TODO :allowance is assumed at 0.2 this value could come from the alowance field of gabarit_dragage table */
DROP TABLE IF EXISTS vol_result_tmp ;
CREATE TEMPORARY TABLE vol_result_tmp  as 
SELECT drag_id,
		sum(st_area (st_polygon )) as area_to_dredge, 
		
		
		(st_summarystatsagg(raster,1,true)).count* (max(st_scalex(raster))*max(st_scalex(raster)) * 0.2) as overdredged_volume,
	 	0::numeric as combined_volume,
		0::numeric as area_to_fill,
		0::numeric as volume_to_fill
FROM volume_surface  WHERE typ = 'over dredging depth' group by drag_id ;

/*Update the vol_result_tmp by seting the area_to_fill and volume_to_fill */																			   
with below as (								
SELECT  drag_id,
		sum(st_area (st_polygon )) as area_to_fill, 
		(st_summarystatsagg(raster,1,true)).sum as volume_to_fill		 
FROM volume_surface WHERE typ = 'below dredging depth'
  group by  drag_id )
UPDATE 	vol_result_tmp v  set area_to_fill = c.area_to_fill, volume_to_fill = c.volume_to_fill
FROM below c where c.drag_id=v.drag_id;

/*put the values of vol_result_tmp in the volumes_computation_results table for persitence of result*/
update vol_result_tmp set 
		 volume_to_dredge = round(volume_to_dredge),
		 overdredged_volume = round(overdredged_volume),
		 combined_volume = round(volume_to_dredge+overdredged_volume),
		 volume_to_fill = round(volume_to_fill);
DELETE FROM volumes_computation_results   WHERE   gabarit = in_gabarit and sounding=in_sounding;
INSERT INTO volumes_computation_results   SELECT   in_gabarit  ,   in_sounding , *  FROM vol_result_tmp;

return 'OK';
END;
$BODY$;
