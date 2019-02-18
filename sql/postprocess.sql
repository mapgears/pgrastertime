--Managing metadata
SELECT dfo_metadata('pgrastertime_tmp');

--Calculate tiles extents at all resolutions.
SELECT dfo_calculate_tile_extents('pgrastertime_tmp');

--Calculate tiles geometries at all resolutions.
SELECT dfo_calculate_tile_geoms('pgrastertime_tmp', 16);
/*SELECT dfo_calculate_tile_geoms('pgrastertime_tmp', 8);
SELECT dfo_calculate_tile_geoms('pgrastertime_tmp', 4);
SELECT dfo_calculate_tile_geoms('pgrastertime_tmp', 2);
SELECT dfo_calculate_tile_geoms('pgrastertime_tmp', 1);
SELECT dfo_calculate_tile_geoms('pgrastertime_tmp', 0.5);
SELECT dfo_calculate_tile_geoms('pgrastertime_tmp', 0.25);
*/

SELECT dfo_merge_bands('pgrastertime_tmp');


--add the conformance band at 16,8,4 and 2 meters resolution.
SELECT dfo_add_conformance_band('pgrastertime_tmp','secteur_sondage','geom_3979',16);
/*SELECT dfo_add_conformance_band_byfile(	'pgrastertime_tmp','secteur_sondage',8);
SELECT dfo_add_conformance_band_byfile(	'pgrastertime_tmp','secteur_sondage',4);
SELECT dfo_add_conformance_band_byfile(	'pgrastertime_tmp','secteur_sondage',2);
*/
--Calculate Shoal geometries at 16,8,4 and 2 meters resolution. 
select dfo_add_shoal_geom ('pgrastertime_tmp', 16,0 );
/*select dfo_add_shoal_geom ('pgrastertime_tmp', 8,0 );
select dfo_add_shoal_geom ('pgrastertime_tmp', 4,0 );
select dfo_add_shoal_geom ('pgrastertime_tmp', 2,0 );
*/

