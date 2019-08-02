
CREATE TABLE soundings_25cm
(
    id serial,
    tile_id bigint,
    rast raster,
    resolution double precision,
    filename text COLLATE pg_catalog."default",
    sys_period tstzrange,
    tile_extent geometry(Polygon),
    tile_geom geometry(MultiPolygon),
    metadata_id character varying(100) COLLATE pg_catalog."default",
    shoal_geom geometry(MultiPolygon,3979),
    CONSTRAINT soundings_25cm_pk PRIMARY KEY (id),
    CONSTRAINT enforce_out_db_rast CHECK (_raster_constraint_out_db(rast) = '{f,f,f,f,f}'::boolean[]),
    CONSTRAINT enforce_nodata_values_rast CHECK (_raster_constraint_nodata_values(rast) = '{340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000}'::numeric[]),
    CONSTRAINT enforce_pixel_types_rast CHECK (_raster_constraint_pixel_types(rast) = '{32BF,32BF,32BF,32BF,32BF}'::text[]),
    CONSTRAINT enforce_num_bands_rast CHECK (st_numbands(rast) = 5),
    CONSTRAINT enforce_scaley_rast CHECK (round(st_scaley(rast)::numeric, 10) = round(- 0.25, 10)),
    CONSTRAINT enforce_scalex_rast CHECK (round(st_scalex(rast)::numeric, 10) = round(0.25, 10)),
    CONSTRAINT enforce_srid_rast CHECK (st_srid(rast) = 3979)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

-- Index: soundings_25cm_lower_sysperiod

-- DROP INDEX soundings_25cm_lower_sysperiod;

CREATE INDEX soundings_25cm_lower_sysperiod
    ON soundings_25cm USING btree
    (lower(sys_period))
    TABLESPACE pg_default;

-- Index: soundings_25cm_metadata_id

-- DROP INDEX soundings_25cm_metadata_id;

CREATE INDEX soundings_25cm_metadata_id
    ON soundings_25cm USING btree
    (metadata_id COLLATE pg_catalog."default")
    TABLESPACE pg_default;

-- Index: soundings_25cm_raster

-- DROP INDEX soundings_25cm_raster;

CREATE INDEX soundings_25cm_raster
    ON soundings_25cm USING gist
    (st_convexhull(rast))
    TABLESPACE pg_default;

-- Index: soundings_25cm_sysperiod

-- DROP INDEX soundings_25cm_sysperiod;

CREATE INDEX soundings_25cm_sysperiod
    ON soundings_25cm USING gist
    (sys_period)
    TABLESPACE pg_default;

-- Index: soundings_25cm_tile_extent_idx

-- DROP INDEX soundings_25cm_tile_extent_idx;

CREATE INDEX soundings_25cm_tile_extent_idx
    ON soundings_25cm USING gist
    (tile_extent)
    TABLESPACE pg_default;

-- Index: soundings_25cm_tile_geom_idx

-- DROP INDEX soundings_25cm_tile_geom_idx;

CREATE INDEX soundings_25cm_tile_geom_idx
    ON soundings_25cm USING gist
    (tile_geom)
    TABLESPACE pg_default;

-- Table: soundings_vnsl_25cm

-- DROP TABLE soundings_vnsl_25cm;

CREATE TABLE soundings_vnsl_25cm
(
    -- Inherited from table soundings_25cm: id integer NOT NULL DEFAULT nextval('soundings_25cm_id_seq'::regclass),
    -- Inherited from table soundings_25cm: tile_id bigint,
    -- Inherited from table soundings_25cm: rast raster,
    -- Inherited from table soundings_25cm: resolution double precision,
    -- Inherited from table soundings_25cm: filename text COLLATE pg_catalog."default",
    -- Inherited from table soundings_25cm: sys_period tstzrange,
    -- Inherited from table soundings_25cm: tile_extent geometry(Polygon),
    -- Inherited from table soundings_25cm: tile_geom geometry(MultiPolygon),
    -- Inherited from table soundings_25cm: metadata_id character varying(100) COLLATE pg_catalog."default",
    -- Inherited from table soundings_25cm: shoal_geom geometry(MultiPolygon,3979),
    CONSTRAINT soundings_vnsl_25cm_pkey PRIMARY KEY (id),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000000000000000D03F000000000000D0BF000000C0ED793941000000007C4DF6C0000000000000000000000000000000008B0F000001000100'::raster)),
    CONSTRAINT enforce_out_db_rast CHECK (_raster_constraint_out_db(rast) = '{f,f,f,f,f}'::boolean[]),
    CONSTRAINT enforce_nodata_values_rast CHECK (_raster_constraint_nodata_values(rast) = '{340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000}'::numeric[]),
    CONSTRAINT enforce_pixel_types_rast CHECK (_raster_constraint_pixel_types(rast) = '{32BF,32BF,32BF,32BF,32BF}'::text[]),
    CONSTRAINT enforce_num_bands_rast CHECK (st_numbands(rast) = 5),
    CONSTRAINT enforce_scaley_rast CHECK (round(st_scaley(rast)::numeric, 10) = round(- 0.25, 10)),
    CONSTRAINT enforce_scalex_rast CHECK (round(st_scalex(rast)::numeric, 10) = round(0.25, 10)),
    CONSTRAINT enforce_srid_rast CHECK (st_srid(rast) = 3979)
)
    INHERITS (soundings_25cm)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;


-- Index: soundings_vnsl_25cm_lower_sysperiod

-- DROP INDEX soundings_vnsl_25cm_lower_sysperiod;

CREATE INDEX soundings_vnsl_25cm_lower_sysperiod
    ON soundings_vnsl_25cm USING btree
    (lower(sys_period))
    TABLESPACE pg_default;

-- Index: soundings_vnsl_25cm_metadata_id

-- DROP INDEX soundings_vnsl_25cm_metadata_id;

CREATE INDEX soundings_vnsl_25cm_metadata_id
    ON soundings_vnsl_25cm USING btree
    (metadata_id COLLATE pg_catalog."default")
    TABLESPACE pg_default;

-- Index: soundings_vnsl_25cm_raster

-- DROP INDEX soundings_vnsl_25cm_raster;

CREATE INDEX soundings_vnsl_25cm_raster
    ON soundings_vnsl_25cm USING gist
    (st_convexhull(rast))
    TABLESPACE pg_default;

-- Index: soundings_vnsl_25cm_sysperiod

-- DROP INDEX soundings_vnsl_25cm_sysperiod;

CREATE INDEX soundings_vnsl_25cm_sysperiod
    ON soundings_vnsl_25cm USING gist
    (sys_period)
    TABLESPACE pg_default;

-- Index: soundings_vnsl_25cm_tile_extent_idx

-- DROP INDEX soundings_vnsl_25cm_tile_extent_idx;

CREATE INDEX soundings_vnsl_25cm_tile_extent_idx
    ON soundings_vnsl_25cm USING gist
    (tile_extent)
    TABLESPACE pg_default;

-- Index: soundings_vnsl_25cm_tile_geom_idx

-- DROP INDEX soundings_vnsl_25cm_tile_geom_idx;

CREATE INDEX soundings_vnsl_25cm_tile_geom_idx
    ON soundings_vnsl_25cm USING gist
    (tile_geom)
    TABLESPACE pg_default;
	


