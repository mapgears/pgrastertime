INSERT INTO xsoundings(id,tile_id,rast,resolution,filename,sys_period,tile_extent,tile_geom,metadata_id,shoal_geom)
SELECT id,tile_id,raster,resolution,filename,sys_period,tile_extent,tile_geom,metadata_id,shoal_geom 
FROM pgrastertime WHERE filename LIKE '%depth%'
