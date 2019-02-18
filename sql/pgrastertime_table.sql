CREATE TABLE IF NOT EXISTS pgrastertime
(
id serial NOT NULL,
tile_id bigint,
raster raster NOT NULL,
resolution double precision,
filename text COLLATE pg_catalog."default",
sys_period tstzrange,
tile_extent geometry(Polygon),
tile_geom geometry(MultiPolygon),
metadata_id character varying(100) COLLATE pg_catalog."default",
shoal_geom geometry(MultiPolygon,3979)
);
