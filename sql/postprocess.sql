--Managing metadata
SELECT dfo_metadata('pgrastertime');

--Calculate tiles extents at all resolutions.
SELECT dfo_calculate_tile_extents('pgrastertime');

--Calculate tiles geometries at all resolutions.
SELECT dfo_calculate_tile_geoms('pgrastertime', 16);
SELECT dfo_calculate_tile_geoms('pgrastertime', 8);
SELECT dfo_calculate_tile_geoms('pgrastertime', 4);
SELECT dfo_calculate_tile_geoms('pgrastertime', 2);
SELECT dfo_calculate_tile_geoms('pgrastertime', 1);
SELECT dfo_calculate_tile_geoms('pgrastertime', 0.5);
SELECT dfo_calculate_tile_geoms('pgrastertime', 0.25);

-- Merge bands in master table
SELECT dfo_merge_bands('pgrastertime');


-- Add the conformance band at 16,8,4 and 2 meters resolution.
SELECT dfo_add_conformance_band('pgrastertime','secteur_sondage','geom_3979',16);
SELECT dfo_add_conformance_band('pgrastertime','secteur_sondage','geom_3979',8);
SELECT dfo_add_conformance_band('pgrastertime','secteur_sondage','geom_3979',4);
SELECT dfo_add_conformance_band('pgrastertime','secteur_sondage','geom_3979',2);

-- Calculate Shoal geometries at 16,8,4 and 2 meters resolution. 
select dfo_add_shoal_geom ('pgrastertime', 16,0 );
select dfo_add_shoal_geom ('pgrastertime', 8,0 );
select dfo_add_shoal_geom ('pgrastertime', 4,0 );
select dfo_add_shoal_geom ('pgrastertime', 2,0 );
