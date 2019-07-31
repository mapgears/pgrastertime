--Managing metadata
SELECT dfo_metadata('pgrastertime','rasterfile');

--Calculate tiles extents at all resolutions.
SELECT dfo_calculate_tile_extents('pgrastertime','rasterfile');

--Calculate tiles geometries at all resolutions.
SELECT dfo_calculate_tile_geoms('pgrastertime', 16,'rasterfile');
SELECT dfo_calculate_tile_geoms('pgrastertime', 8,'rasterfile');
SELECT dfo_calculate_tile_geoms('pgrastertime', 4,'rasterfile');
SELECT dfo_calculate_tile_geoms('pgrastertime', 2,'rasterfile');
SELECT dfo_calculate_tile_geoms('pgrastertime', 1,'rasterfile');
SELECT dfo_calculate_tile_geoms('pgrastertime', 0.5,'rasterfile');
SELECT dfo_calculate_tile_geoms('pgrastertime', 0.25,'rasterfile');


-- Merge bands in master table
--SELECT dfo_merge_bands('pgrastertime','rasterfile');
