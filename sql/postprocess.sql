--Managing metadata
SELECT dfo_delete_empty_tiles('pgrastertime','rasterfile');

--Calculate tiles extents at all resolutions.
SELECT dfo_calculate_tile_extents('pgrastertime','rasterfile');

--Calculate tiles geometries at all resolutions.
SELECT dfo_calculate_tile_geoms('pgrastertime', 16,'rasterfile');
SELECT dfo_calculate_tile_geoms('pgrastertime', 8,'rasterfile');
SELECT dfo_calculate_tile_geoms('pgrastertime', 4,'rasterfile');
SELECT dfo_calculate_tile_geoms('pgrastertime', 2,'rasterfile');
SELECT dfo_calculate_tile_geoms('pgrastertime', 1,'rasterfile');

--Managing metadata
SELECT dfo_metadata('pgrastertime','rasterfile');

-- Merge bands in master table
SELECT dfo_merge_bands('pgrastertime','rasterfile');

-- Add the conformance band at 16,8,4 and 2 meters resolution.
SELECT dfo_add_conformance_band('pgrastertime','design_grade_s','geom_3979',16,'rasterfile');
SELECT dfo_add_conformance_band('pgrastertime','design_grade_s','geom_3979',8,'rasterfile');
SELECT dfo_add_conformance_band('pgrastertime','design_grade_s','geom_3979',4,'rasterfile');
SELECT dfo_add_conformance_band('pgrastertime','design_grade_s','geom_3979',2,'rasterfile');
SELECT dfo_add_conformance_band('pgrastertime','design_grade_s','geom_3979',1,'rasterfile');

-- Calculate Shoal geometries at 16,8,4 and 2 meters resolution.
select dfo_add_shoal_geom ('pgrastertime', 16,0,'rasterfile' );
select dfo_add_shoal_geom ('pgrastertime', 8,0,'rasterfile' );
select dfo_add_shoal_geom ('pgrastertime', 4,0,'rasterfile' );
select dfo_add_shoal_geom ('pgrastertime', 2,0,'rasterfile' );
select dfo_add_shoal_geom ('pgrastertime', 1,0,'rasterfile' );

