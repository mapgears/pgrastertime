SELECT 'avec conformance' as raster_type ,st_numbands(raster)=5 as num_of_bands ,resolution>=2 as resolution, 
        st_area(tile_geom ) >0 as raster_tile_geom, 
        st_area(tile_extent) >0 as raster_tile_extent,
        sys_Period is not null as time_set 
FROM pgrastertime 
WHERE resolution>=2
GROUP BY st_numbands(raster)=5 ,resolution>=2 , st_area(tile_geom ) >0 , st_area(tile_extent) >0 ,sys_Period is not null
UNION
SELECT 'sans conformance' as raster_type,st_numbands(raster)=4  as num_of_bands,resolution<2 as resolution, 
        st_area(tile_geom ) >0 as raster_tile_geom, st_area(tile_extent) >0 as raster_tile_extent, 
        sys_Period is not null  as time_set
FROM pgrastertime 
WHERE resolution<2
GROUP BY st_numbands(raster)=4 ,resolution<2 , st_area(tile_geom ) >0 , st_area(tile_extent) >0 ,sys_Period is not null
