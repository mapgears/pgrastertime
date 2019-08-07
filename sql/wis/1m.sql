-- Table: soundings_1m

-- DROP TABLE soundings_1m;

CREATE TABLE soundings_1m
(
    id serial NOT NULL,
    tile_id bigint,
    rast raster,
    resolution double precision,
    filename text COLLATE pg_catalog."default",
    sys_period tstzrange,
    tile_extent geometry(Polygon),
    tile_geom geometry(MultiPolygon),
    metadata_id character varying(100) COLLATE pg_catalog."default",
    shoal_geom geometry(MultiPolygon,3979),
    CONSTRAINT soundings_1m_pk PRIMARY KEY (id),
    CONSTRAINT enforce_out_db_rast CHECK (_raster_constraint_out_db(rast) = '{f,f,f,f,f}'::boolean[]),
    CONSTRAINT enforce_nodata_values_rast CHECK (_raster_constraint_nodata_values(rast) = '{340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000}'::numeric[]),
    CONSTRAINT enforce_pixel_types_rast CHECK (_raster_constraint_pixel_types(rast) = '{32BF,32BF,32BF,32BF,32BF}'::text[]),
    CONSTRAINT enforce_num_bands_rast CHECK (st_numbands(rast) = 5),
    CONSTRAINT enforce_scaley_rast CHECK (round(st_scaley(rast)::numeric, 10) = round(- 1::numeric, 10)),
    CONSTRAINT enforce_scalex_rast CHECK (round(st_scalex(rast)::numeric, 10) = round(1::numeric, 10)),
    CONSTRAINT enforce_srid_rast CHECK (st_srid(rast) = 3979)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

-- Index: soundings_1m_lower_sysperiod

-- DROP INDEX soundings_1m_lower_sysperiod;

CREATE INDEX soundings_1m_lower_sysperiod
    ON soundings_1m USING btree
    (lower(sys_period))
    TABLESPACE pg_default;

-- Index: soundings_1m_metadata_id

-- DROP INDEX soundings_1m_metadata_id;

CREATE INDEX soundings_1m_metadata_id
    ON soundings_1m USING btree
    (metadata_id COLLATE pg_catalog."default")
    TABLESPACE pg_default;

-- Index: soundings_1m_raster

-- DROP INDEX soundings_1m_raster;

CREATE INDEX soundings_1m_raster
    ON soundings_1m USING gist
    (st_convexhull(rast))
    TABLESPACE pg_default;

-- Index: soundings_1m_sysperiod

-- DROP INDEX soundings_1m_sysperiod;

CREATE INDEX soundings_1m_sysperiod
    ON soundings_1m USING gist
    (sys_period)
    TABLESPACE pg_default;

-- Index: soundings_1m_tile_extent_idx

-- DROP INDEX soundings_1m_tile_extent_idx;

CREATE INDEX soundings_1m_tile_extent_idx
    ON soundings_1m USING gist
    (tile_extent)
    TABLESPACE pg_default;

-- Index: soundings_1m_tile_geom_idx

-- DROP INDEX soundings_1m_tile_geom_idx;

CREATE INDEX soundings_1m_tile_geom_idx
    ON soundings_1m USING gist
    (tile_geom)
    TABLESPACE pg_default;

-- Table: soundings_vnsl_1m

-- DROP TABLE soundings_vnsl_1m;

CREATE TABLE soundings_vnsl_1m
(
    -- Inherited from table soundings_1m: id integer NOT NULL DEFAULT nextval('soundings_1m_id_seq'::regclass),
    -- Inherited from table soundings_1m: tile_id bigint,
    -- Inherited from table soundings_1m: rast raster,
    -- Inherited from table soundings_1m: resolution double precision,
    -- Inherited from table soundings_1m: filename text COLLATE pg_catalog."default",
    -- Inherited from table soundings_1m: sys_period tstzrange,
    -- Inherited from table soundings_1m: tile_extent geometry(Polygon),
    -- Inherited from table soundings_1m: tile_geom geometry(MultiPolygon),
    -- Inherited from table soundings_1m: metadata_id character varying(100) COLLATE pg_catalog."default",
    -- Inherited from table soundings_1m: shoal_geom geometry(MultiPolygon,3979),
    CONSTRAINT soundings_vnsl_1m_pkey PRIMARY KEY (id),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000000000000000F03F000000000000F0BF00000000DF7B3941000000003078F8C0000000000000000000000000000000008B0F000001000100'::raster)),
    CONSTRAINT enforce_out_db_rast CHECK (_raster_constraint_out_db(rast) = '{f,f,f,f,f}'::boolean[]),
    CONSTRAINT enforce_nodata_values_rast CHECK (_raster_constraint_nodata_values(rast) = '{340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000}'::numeric[]),
    CONSTRAINT enforce_pixel_types_rast CHECK (_raster_constraint_pixel_types(rast) = '{32BF,32BF,32BF,32BF,32BF}'::text[]),
    CONSTRAINT enforce_scaley_rast CHECK (round(st_scaley(rast)::numeric, 10) = round(- 1::numeric, 10)),
    CONSTRAINT enforce_scalex_rast CHECK (round(st_scalex(rast)::numeric, 10) = round(1::numeric, 10)),
    CONSTRAINT enforce_srid_rast CHECK (st_srid(rast) = 3979),
    CONSTRAINT enforce_num_bands_rast CHECK (st_numbands(rast) = 5)
)
    INHERITS (soundings_1m)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE soundings_vnsl_1m
    OWNER to stecyr;

-- Index: soundings_vnsl_1m_lower_sysperiod

-- DROP INDEX soundings_vnsl_1m_lower_sysperiod;

CREATE INDEX soundings_vnsl_1m_lower_sysperiod
    ON soundings_vnsl_1m USING btree
    (lower(sys_period))
    TABLESPACE pg_default;

-- Index: soundings_vnsl_1m_metadata_id

-- DROP INDEX soundings_vnsl_1m_metadata_id;

CREATE INDEX soundings_vnsl_1m_metadata_id
    ON soundings_vnsl_1m USING btree
    (metadata_id COLLATE pg_catalog."default")
    TABLESPACE pg_default;

-- Index: soundings_vnsl_1m_raster

-- DROP INDEX soundings_vnsl_1m_raster;

CREATE INDEX soundings_vnsl_1m_raster
    ON soundings_vnsl_1m USING gist
    (st_convexhull(rast))
    TABLESPACE pg_default;

-- Index: soundings_vnsl_1m_sysperiod

-- DROP INDEX soundings_vnsl_1m_sysperiod;

CREATE INDEX soundings_vnsl_1m_sysperiod
    ON soundings_vnsl_1m USING gist
    (sys_period)
    TABLESPACE pg_default;

-- Index: soundings_vnsl_1m_tile_extent_idx

-- DROP INDEX soundings_vnsl_1m_tile_extent_idx;

CREATE INDEX soundings_vnsl_1m_tile_extent_idx
    ON soundings_vnsl_1m USING gist
    (tile_extent)
    TABLESPACE pg_default;

-- Index: soundings_vnsl_1m_tile_geom_idx

-- DROP INDEX soundings_vnsl_1m_tile_geom_idx;

CREATE INDEX soundings_vnsl_1m_tile_geom_idx
    ON soundings_vnsl_1m USING gist
    (tile_geom)
    TABLESPACE pg_default;
