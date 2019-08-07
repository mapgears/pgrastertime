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


-- Table: soundings.soundings_50cm

-- DROP TABLE soundings.soundings_50cm;

CREATE TABLE soundings_50cm
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
    CONSTRAINT soundings_50cm_pk PRIMARY KEY (id),
    CONSTRAINT enforce_out_db_rast CHECK (_raster_constraint_out_db(rast) = '{f,f,f,f,f}'::boolean[]),
    CONSTRAINT enforce_nodata_values_rast CHECK (_raster_constraint_nodata_values(rast) = '{340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000}'::numeric[]),
    CONSTRAINT enforce_pixel_types_rast CHECK (_raster_constraint_pixel_types(rast) = '{32BF,32BF,32BF,32BF,32BF}'::text[]),
    CONSTRAINT enforce_num_bands_rast CHECK (st_numbands(rast) = 5),
    CONSTRAINT enforce_scaley_rast CHECK (round(st_scaley(rast)::numeric, 10) = round(- 0.50, 10)),
    CONSTRAINT enforce_scalex_rast CHECK (round(st_scalex(rast)::numeric, 10) = round(0.50, 10)),
    CONSTRAINT enforce_srid_rast CHECK (st_srid(rast) = 3979)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

-- Index: soundings_50cm_lower_sysperiod

-- DROP INDEX soundings_50cm_lower_sysperiod;

CREATE INDEX soundings_50cm_lower_sysperiod
    ON soundings_50cm USING btree
    (lower(sys_period))
    TABLESPACE pg_default;

-- Index: soundings_50cm_metadata_id

-- DROP INDEX soundings_50cm_metadata_id;

CREATE INDEX soundings_50cm_metadata_id
    ON soundings_50cm USING btree
    (metadata_id COLLATE pg_catalog."default")
    TABLESPACE pg_default;

-- Index: soundings_50cm_raster

-- DROP INDEX soundings_50cm_raster;

CREATE INDEX soundings_50cm_raster
    ON soundings_50cm USING gist
    (st_convexhull(rast))
    TABLESPACE pg_default;

-- Index: soundings_50cm_sysperiod

-- DROP INDEX soundings_50cm_sysperiod;

CREATE INDEX soundings_50cm_sysperiod
    ON soundings_50cm USING gist
    (sys_period)
    TABLESPACE pg_default;

-- Index: soundings_50cm_tile_extent_idx

-- DROP INDEX soundings_50cm_tile_extent_idx;

CREATE INDEX soundings_50cm_tile_extent_idx
    ON soundings_50cm USING gist
    (tile_extent)
    TABLESPACE pg_default;

-- Index: soundings_50cm_tile_geom_idx

-- DROP INDEX soundings_50cm_tile_geom_idx;

CREATE INDEX soundings_50cm_tile_geom_idx
    ON soundings_50cm USING gist
    (tile_geom)
    TABLESPACE pg_default;
    
    -- Table: soundings_vnsl_50cm

-- DROP TABLE soundings_vnsl_50cm;

CREATE TABLE soundings_vnsl_50cm
(
    -- Inherited from table soundings_50cm: id integer NOT NULL DEFAULT nextval('soundings_50cm_id_seq'::regclass),
    -- Inherited from table soundings_50cm: tile_id bigint,
    -- Inherited from table soundings_50cm: rast raster,
    -- Inherited from table soundings_50cm: resolution double precision,
    -- Inherited from table soundings_50cm: filename text COLLATE pg_catalog."default",
    -- Inherited from table soundings_50cm: sys_period tstzrange,
    -- Inherited from table soundings_50cm: tile_extent geometry(Polygon),
    -- Inherited from table soundings_50cm: tile_geom geometry(MultiPolygon),
    -- Inherited from table soundings_50cm: metadata_id character varying(100) COLLATE pg_catalog."default",
    -- Inherited from table soundings_50cm: shoal_geom geometry(MultiPolygon,3979),
    CONSTRAINT soundings_vnsl_50cm_pkey PRIMARY KEY (id),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000000000000000E03F000000000000E0BF000000004E9A3941000000002099E7C0000000000000000000000000000000008B0F000001000100'::raster)),
    CONSTRAINT enforce_out_db_rast CHECK (_raster_constraint_out_db(rast) = '{f,f,f,f,f}'::boolean[]),
    CONSTRAINT enforce_nodata_values_rast CHECK (_raster_constraint_nodata_values(rast) = '{340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000}'::numeric[]),
    CONSTRAINT enforce_pixel_types_rast CHECK (_raster_constraint_pixel_types(rast) = '{32BF,32BF,32BF,32BF,32BF}'::text[]),
    CONSTRAINT enforce_num_bands_rast CHECK (st_numbands(rast) = 5),
    CONSTRAINT enforce_scaley_rast CHECK (round(st_scaley(rast)::numeric, 10) = round(- 0.50, 10)),
    CONSTRAINT enforce_scalex_rast CHECK (round(st_scalex(rast)::numeric, 10) = round(0.50, 10)),
    CONSTRAINT enforce_srid_rast CHECK (st_srid(rast) = 3979)
)
    INHERITS (soundings_50cm)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

-- Index: soundings_vnsl_50cm_lower_sysperiod

-- DROP INDEX soundings_vnsl_50cm_lower_sysperiod;

CREATE INDEX soundings_vnsl_50cm_lower_sysperiod
    ON soundings_vnsl_50cm USING btree
    (lower(sys_period))
    TABLESPACE pg_default;

-- Index: soundings_vnsl_50cm_metadata_id

-- DROP INDEX soundings_vnsl_50cm_metadata_id;

CREATE INDEX soundings_vnsl_50cm_metadata_id
    ON soundings_vnsl_50cm USING btree
    (metadata_id COLLATE pg_catalog."default")
    TABLESPACE pg_default;

-- Index: soundings_vnsl_50cm_raster

-- DROP INDEX soundings_vnsl_50cm_raster;

CREATE INDEX soundings_vnsl_50cm_raster
    ON soundings_vnsl_50cm USING gist
    (st_convexhull(rast))
    TABLESPACE pg_default;

-- Index: soundings_vnsl_50cm_sysperiod

-- DROP INDEX soundings_vnsl_50cm_sysperiod;

CREATE INDEX soundings_vnsl_50cm_sysperiod
    ON soundings_vnsl_50cm USING gist
    (sys_period)
    TABLESPACE pg_default;

-- Index: soundings_vnsl_50cm_tile_extent_idx

-- DROP INDEX soundings_vnsl_50cm_tile_extent_idx;

CREATE INDEX soundings_vnsl_50cm_tile_extent_idx
    ON soundings_vnsl_50cm USING gist
    (tile_extent)
    TABLESPACE pg_default;

-- Index: soundings_vnsl_50cm_tile_geom_idx

-- DROP INDEX soundings_vnsl_50cm_tile_geom_idx;

CREATE INDEX soundings_vnsl_50cm_tile_geom_idx
    ON soundings_vnsl_50cm USING gist
    (tile_geom)
TABLESPACE pg_default;


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

-- Table: soundings_2m

-- DROP TABLE soundings_2m;

CREATE TABLE soundings_2m
(
    id serial NOT NULL ,
    tile_id bigint,
    rast raster,
    resolution double precision,
    filename text COLLATE pg_catalog."default",
    sys_period tstzrange,
    tile_extent geometry(Polygon),
    tile_geom geometry(MultiPolygon),
    metadata_id character varying(100) COLLATE pg_catalog."default",
    shoal_geom geometry(MultiPolygon,3979),
    CONSTRAINT soundings_2m_pk PRIMARY KEY (id),
    CONSTRAINT enforce_out_db_rast CHECK (_raster_constraint_out_db(rast) = '{f,f,f,f,f}'::boolean[]),
    CONSTRAINT enforce_nodata_values_rast CHECK (_raster_constraint_nodata_values(rast) = '{340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000}'::numeric[]),
    CONSTRAINT enforce_pixel_types_rast CHECK (_raster_constraint_pixel_types(rast) = '{32BF,32BF,32BF,32BF,32BF}'::text[]),
    CONSTRAINT enforce_num_bands_rast CHECK (st_numbands(rast) = 5),
    CONSTRAINT enforce_scaley_rast CHECK (round(st_scaley(rast)::numeric, 10) = round(- 2::numeric, 10)),
    CONSTRAINT enforce_scalex_rast CHECK (round(st_scalex(rast)::numeric, 10) = round(2::numeric, 10)),
    CONSTRAINT enforce_srid_rast CHECK (st_srid(rast) = 3979)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

-- Index: soundings_2m_lower_sysperiod

-- DROP INDEX soundings_2m_lower_sysperiod;

CREATE INDEX soundings_2m_lower_sysperiod
    ON soundings_2m USING btree
    (lower(sys_period))
    TABLESPACE pg_default;

-- Index: soundings_2m_metadata_id

-- DROP INDEX soundings_2m_metadata_id;

CREATE INDEX soundings_2m_metadata_id
    ON soundings_2m USING btree
    (metadata_id COLLATE pg_catalog."default")
    TABLESPACE pg_default;

-- Index: soundings_2m_raster

-- DROP INDEX soundings_2m_raster;

CREATE INDEX soundings_2m_raster
    ON soundings_2m USING gist
    (st_convexhull(rast))
    TABLESPACE pg_default;

-- Index: soundings_2m_sysperiod

-- DROP INDEX soundings_2m_sysperiod;

CREATE INDEX soundings_2m_sysperiod
    ON soundings_2m USING gist
    (sys_period)
    TABLESPACE pg_default;

-- Index: soundings_2m_tile_extent_idx

-- DROP INDEX soundings_2m_tile_extent_idx;

CREATE INDEX soundings_2m_tile_extent_idx
    ON soundings_2m USING gist
    (tile_extent)
    TABLESPACE pg_default;

-- Index: soundings_2m_tile_geom_idx

-- DROP INDEX soundings_2m_tile_geom_idx;

CREATE INDEX soundings_2m_tile_geom_idx
    ON soundings_2m USING gist
    (tile_geom)
    TABLESPACE pg_default;
    
    -- Table: soundings_vnsl_2m

-- DROP TABLE soundings_vnsl_2m;

CREATE TABLE soundings_vnsl_2m
(
    -- Inherited from table soundings_2m: id integer NOT NULL DEFAULT nextval('soundings_2m_id_seq'::regclass),
    -- Inherited from table soundings_2m: tile_id bigint,
    -- Inherited from table soundings_2m: rast raster,
    -- Inherited from table soundings_2m: resolution double precision,
    -- Inherited from table soundings_2m: filename text COLLATE pg_catalog."default",
    -- Inherited from table soundings_2m: sys_period tstzrange,
    -- Inherited from table soundings_2m: tile_extent geometry(Polygon),
    -- Inherited from table soundings_2m: tile_geom geometry(MultiPolygon),
    -- Inherited from table soundings_2m: metadata_id character varying(100) COLLATE pg_catalog."default",
    -- Inherited from table soundings_2m: shoal_geom geometry(MultiPolygon,3979),
    CONSTRAINT soundings_vnsl_2m_pkey PRIMARY KEY (id),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000000000000000004000000000000000C0000000005C783941000000002061F7C0000000000000000000000000000000008B0F000001000100'::raster)),
    CONSTRAINT enforce_out_db_rast CHECK (_raster_constraint_out_db(rast) = '{f,f,f,f,f}'::boolean[]),
    CONSTRAINT enforce_nodata_values_rast CHECK (_raster_constraint_nodata_values(rast) = '{340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000}'::numeric[]),
    CONSTRAINT enforce_pixel_types_rast CHECK (_raster_constraint_pixel_types(rast) = '{32BF,32BF,32BF,32BF,32BF}'::text[]),
    CONSTRAINT enforce_scaley_rast CHECK (round(st_scaley(rast)::numeric, 10) = round(- 2::numeric, 10)),
    CONSTRAINT enforce_srid_rast CHECK (st_srid(rast) = 3979),
    CONSTRAINT enforce_scalex_rast CHECK (round(st_scalex(rast)::numeric, 10) = round(2::numeric, 10)),
    CONSTRAINT enforce_num_bands_rast CHECK (st_numbands(rast) = 5)
)
    INHERITS (soundings_2m)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

-- Index: soundings_vnsl_2m_lower_sysperiod

-- DROP INDEX soundings_vnsl_2m_lower_sysperiod;

CREATE INDEX soundings_vnsl_2m_lower_sysperiod
    ON soundings_vnsl_2m USING btree
    (lower(sys_period))
    TABLESPACE pg_default;

-- Index: soundings_vnsl_2m_metadata_id

-- DROP INDEX soundings_vnsl_2m_metadata_id;

CREATE INDEX soundings_vnsl_2m_metadata_id
    ON soundings_vnsl_2m USING btree
    (metadata_id COLLATE pg_catalog."default")
    TABLESPACE pg_default;

-- Index: soundings_vnsl_2m_raster

-- DROP INDEX soundings_vnsl_2m_raster;

CREATE INDEX soundings_vnsl_2m_raster
    ON soundings_vnsl_2m USING gist
    (st_convexhull(rast))
    TABLESPACE pg_default;

-- Index: soundings_vnsl_2m_sysperiod

-- DROP INDEX soundings_vnsl_2m_sysperiod;

CREATE INDEX soundings_vnsl_2m_sysperiod
    ON soundings_vnsl_2m USING gist
    (sys_period)
    TABLESPACE pg_default;

-- Index: soundings_vnsl_2m_tile_extent_idx

-- DROP INDEX soundings_vnsl_2m_tile_extent_idx;

CREATE INDEX soundings_vnsl_2m_tile_extent_idx
    ON soundings_vnsl_2m USING gist
    (tile_extent)
    TABLESPACE pg_default;

-- Index: soundings_vnsl_2m_tile_geom_idx

-- DROP INDEX soundings_vnsl_2m_tile_geom_idx;

CREATE INDEX soundings_vnsl_2m_tile_geom_idx
    ON soundings_vnsl_2m USING gist
    (tile_geom)
TABLESPACE pg_default;

-- Table: soundings_4m

-- DROP TABLE soundings_4m;

CREATE TABLE soundings_4m
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
    CONSTRAINT soundings_4m_pk PRIMARY KEY (id),
    CONSTRAINT enforce_out_db_rast CHECK (_raster_constraint_out_db(rast) = '{f,f,f,f,f}'::boolean[]),
    CONSTRAINT enforce_nodata_values_rast CHECK (_raster_constraint_nodata_values(rast) = '{340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000}'::numeric[]),
    CONSTRAINT enforce_pixel_types_rast CHECK (_raster_constraint_pixel_types(rast) = '{32BF,32BF,32BF,32BF,32BF}'::text[]),
    CONSTRAINT enforce_num_bands_rast CHECK (st_numbands(rast) = 5),
    CONSTRAINT enforce_scaley_rast CHECK (round(st_scaley(rast)::numeric, 10) = round(- 4::numeric, 10)),
    CONSTRAINT enforce_scalex_rast CHECK (round(st_scalex(rast)::numeric, 10) = round(4::numeric, 10)),
    CONSTRAINT enforce_srid_rast CHECK (st_srid(rast) = 3979)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

-- Index: soundings_4m_lower_sysperiod

-- DROP INDEX soundings_4m_lower_sysperiod;

CREATE INDEX soundings_4m_lower_sysperiod
    ON soundings_4m USING btree
    (lower(sys_period))
    TABLESPACE pg_default;

-- Index: soundings_4m_metadata_id

-- DROP INDEX soundings_4m_metadata_id;

CREATE INDEX soundings_4m_metadata_id
    ON soundings_4m USING btree
    (metadata_id COLLATE pg_catalog."default")
    TABLESPACE pg_default;

-- Index: soundings_4m_raster

-- DROP INDEX soundings_4m_raster;

CREATE INDEX soundings_4m_raster
    ON soundings_4m USING gist
    (st_convexhull(rast))
    TABLESPACE pg_default;

-- Index: soundings_4m_sysperiod

-- DROP INDEX soundings_4m_sysperiod;

CREATE INDEX soundings_4m_sysperiod
    ON soundings_4m USING gist
    (sys_period)
    TABLESPACE pg_default;

-- Index: soundings_4m_tile_extent_idx

-- DROP INDEX soundings_4m_tile_extent_idx;

CREATE INDEX soundings_4m_tile_extent_idx
    ON soundings_4m USING gist
    (tile_extent)
    TABLESPACE pg_default;

-- Index: soundings_4m_tile_geom_idx

-- DROP INDEX soundings_4m_tile_geom_idx;

CREATE INDEX soundings_4m_tile_geom_idx
    ON soundings_4m USING gist
    (tile_geom)
    TABLESPACE pg_default;
    
    -- Table: soundings_vnsl_4m

-- DROP TABLE soundings_vnsl_4m;

CREATE TABLE soundings_vnsl_4m
(
    -- Inherited from table soundings_4m: id integer NOT NULL DEFAULT nextval('soundings_4m_id_seq'::regclass),
    -- Inherited from table soundings_4m: tile_id bigint,
    -- Inherited from table soundings_4m: rast raster,
    -- Inherited from table soundings_4m: resolution double precision,
    -- Inherited from table soundings_4m: filename text COLLATE pg_catalog."default",
    -- Inherited from table soundings_4m: sys_period tstzrange,
    -- Inherited from table soundings_4m: tile_extent geometry(Polygon),
    -- Inherited from table soundings_4m: tile_geom geometry(MultiPolygon),
    -- Inherited from table soundings_4m: metadata_id character varying(100) COLLATE pg_catalog."default",
    -- Inherited from table soundings_4m: shoal_geom geometry(MultiPolygon,3979),
    CONSTRAINT soundings_vnsl_4m_pkey PRIMARY KEY (id),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000000000000000104000000000000010C000000000FC7A39410000000000B1F8C0000000000000000000000000000000008B0F000001000100'::raster)),
    CONSTRAINT enforce_out_db_rast CHECK (_raster_constraint_out_db(rast) = '{f,f,f,f,f}'::boolean[]),
    CONSTRAINT enforce_nodata_values_rast CHECK (_raster_constraint_nodata_values(rast) = '{340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000}'::numeric[]),
    CONSTRAINT enforce_pixel_types_rast CHECK (_raster_constraint_pixel_types(rast) = '{32BF,32BF,32BF,32BF,32BF}'::text[]),
    CONSTRAINT enforce_scaley_rast CHECK (round(st_scaley(rast)::numeric, 10) = round(- 4::numeric, 10)),
    CONSTRAINT enforce_scalex_rast CHECK (round(st_scalex(rast)::numeric, 10) = round(4::numeric, 10)),
    CONSTRAINT enforce_srid_rast CHECK (st_srid(rast) = 3979),
    CONSTRAINT enforce_num_bands_rast CHECK (st_numbands(rast) = 5)
)
    INHERITS (soundings_4m)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

-- Index: soundings_vnsl_4m_lower_sysperiod

-- DROP INDEX soundings_vnsl_4m_lower_sysperiod;

CREATE INDEX soundings_vnsl_4m_lower_sysperiod
    ON soundings_vnsl_4m USING btree
    (lower(sys_period))
    TABLESPACE pg_default;

-- Index: soundings_vnsl_4m_metadata_id

-- DROP INDEX soundings_vnsl_4m_metadata_id;

CREATE INDEX soundings_vnsl_4m_metadata_id
    ON soundings_vnsl_4m USING btree
    (metadata_id COLLATE pg_catalog."default")
    TABLESPACE pg_default;

-- Index: soundings_vnsl_4m_raster

-- DROP INDEX soundings_vnsl_4m_raster;

CREATE INDEX soundings_vnsl_4m_raster
    ON soundings_vnsl_4m USING gist
    (st_convexhull(rast))
    TABLESPACE pg_default;

-- Index: soundings_vnsl_4m_sysperiod

-- DROP INDEX soundings_vnsl_4m_sysperiod;

CREATE INDEX soundings_vnsl_4m_sysperiod
    ON soundings_vnsl_4m USING gist
    (sys_period)
    TABLESPACE pg_default;

-- Index: soundings_vnsl_4m_tile_extent_idx

-- DROP INDEX soundings_vnsl_4m_tile_extent_idx;

CREATE INDEX soundings_vnsl_4m_tile_extent_idx
    ON soundings_vnsl_4m USING gist
    (tile_extent)
    TABLESPACE pg_default;

-- Index: soundings_vnsl_4m_tile_geom_idx

-- DROP INDEX soundings_vnsl_4m_tile_geom_idx;

CREATE INDEX soundings_vnsl_4m_tile_geom_idx
    ON soundings_vnsl_4m USING gist
    (tile_geom)
TABLESPACE pg_default;

-- Table: soundings_8m

-- DROP TABLE soundings_8m;

CREATE TABLE soundings_8m
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
    CONSTRAINT soundings_8m_pk PRIMARY KEY (id),
    CONSTRAINT enforce_out_db_rast CHECK (_raster_constraint_out_db(rast) = '{f,f,f,f,f}'::boolean[]),
    CONSTRAINT enforce_nodata_values_rast CHECK (_raster_constraint_nodata_values(rast) = '{340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000}'::numeric[]),
    CONSTRAINT enforce_pixel_types_rast CHECK (_raster_constraint_pixel_types(rast) = '{32BF,32BF,32BF,32BF,32BF}'::text[]),
    CONSTRAINT enforce_num_bands_rast CHECK (st_numbands(rast) = 5),
    CONSTRAINT enforce_scaley_rast CHECK (round(st_scaley(rast)::numeric, 10) = round(- 8::numeric, 10)),
    CONSTRAINT enforce_scalex_rast CHECK (round(st_scalex(rast)::numeric, 10) = round(8::numeric, 10)),
    CONSTRAINT enforce_srid_rast CHECK (st_srid(rast) = 3979)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

-- Index: soundings_8m_lower_sysperiod

-- DROP INDEX soundings_8m_lower_sysperiod;

CREATE INDEX soundings_8m_lower_sysperiod
    ON soundings_8m USING btree
    (lower(sys_period))
    TABLESPACE pg_default;

-- Index: soundings_8m_metadata_id

-- DROP INDEX soundings_8m_metadata_id;

CREATE INDEX soundings_8m_metadata_id
    ON soundings_8m USING btree
    (metadata_id COLLATE pg_catalog."default")
    TABLESPACE pg_default;

-- Index: soundings_8m_raster

-- DROP INDEX soundings_8m_raster;

CREATE INDEX soundings_8m_raster
    ON soundings_8m USING gist
    (st_convexhull(rast))
    TABLESPACE pg_default;

-- Index: soundings_8m_sysperiod

-- DROP INDEX soundings_8m_sysperiod;

CREATE INDEX soundings_8m_sysperiod
    ON soundings_8m USING gist
    (sys_period)
    TABLESPACE pg_default;

-- Index: soundings_8m_tile_extent_idx

-- DROP INDEX soundings_8m_tile_extent_idx;

CREATE INDEX soundings_8m_tile_extent_idx
    ON soundings_8m USING gist
    (tile_extent)
    TABLESPACE pg_default;

-- Index: soundings_8m_tile_geom_idx

-- DROP INDEX soundings_8m_tile_geom_idx;

CREATE INDEX soundings_8m_tile_geom_idx
    ON soundings_8m USING gist
    (tile_geom)
    TABLESPACE pg_default;
    
-- Table: soundings_vnsl_8m

-- DROP TABLE soundings_vnsl_8m;

CREATE TABLE soundings_vnsl_8m
(
    -- Inherited from table soundings_8m: id integer NOT NULL DEFAULT nextval('soundings_8m_id_seq'::regclass),
    -- Inherited from table soundings_8m: tile_id bigint,
    -- Inherited from table soundings_8m: rast raster,
    -- Inherited from table soundings_8m: resolution double precision,
    -- Inherited from table soundings_8m: filename text COLLATE pg_catalog."default",
    -- Inherited from table soundings_8m: sys_period tstzrange,
    -- Inherited from table soundings_8m: tile_extent geometry(Polygon),
    -- Inherited from table soundings_8m: tile_geom geometry(MultiPolygon),
    -- Inherited from table soundings_8m: metadata_id character varying(100) COLLATE pg_catalog."default",
    -- Inherited from table soundings_8m: shoal_geom geometry(MultiPolygon,3979),
    CONSTRAINT soundings_vnsl_8m_pkey PRIMARY KEY (id),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000000000000000204000000000000020C00000000048763941000000000047F9C0000000000000000000000000000000008B0F000001000100'::raster)),
    CONSTRAINT enforce_out_db_rast CHECK (_raster_constraint_out_db(rast) = '{f,f,f,f,f}'::boolean[]),
    CONSTRAINT enforce_nodata_values_rast CHECK (_raster_constraint_nodata_values(rast) = '{340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000}'::numeric[]),
    CONSTRAINT enforce_pixel_types_rast CHECK (_raster_constraint_pixel_types(rast) = '{32BF,32BF,32BF,32BF,32BF}'::text[]),
    CONSTRAINT enforce_num_bands_rast CHECK (st_numbands(rast) = 5),
    CONSTRAINT enforce_scaley_rast CHECK (round(st_scaley(rast)::numeric, 10) = round(- 8::numeric, 10)),
    CONSTRAINT enforce_scalex_rast CHECK (round(st_scalex(rast)::numeric, 10) = round(8::numeric, 10)),
    CONSTRAINT enforce_srid_rast CHECK (st_srid(rast) = 3979)
)
    INHERITS (soundings_8m)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;


-- Index: soundings_vnsl_8m_lower_sysperiod

-- DROP INDEX soundings_vnsl_8m_lower_sysperiod;

CREATE INDEX soundings_vnsl_8m_lower_sysperiod
    ON soundings_vnsl_8m USING btree
    (lower(sys_period))
    TABLESPACE pg_default;

-- Index: soundings_vnsl_8m_metadata_id

-- DROP INDEX soundings_vnsl_8m_metadata_id;

CREATE INDEX soundings_vnsl_8m_metadata_id
    ON soundings_vnsl_8m USING btree
    (metadata_id COLLATE pg_catalog."default")
    TABLESPACE pg_default;

-- Index: soundings_vnsl_8m_raster

-- DROP INDEX soundings_vnsl_8m_raster;

CREATE INDEX soundings_vnsl_8m_raster
    ON soundings_vnsl_8m USING gist
    (st_convexhull(rast))
    TABLESPACE pg_default;

-- Index: soundings_vnsl_8m_sysperiod

-- DROP INDEX soundings_vnsl_8m_sysperiod;

CREATE INDEX soundings_vnsl_8m_sysperiod
    ON soundings_vnsl_8m USING gist
    (sys_period)
    TABLESPACE pg_default;

-- Index: soundings_vnsl_8m_tile_extent_idx

-- DROP INDEX soundings_vnsl_8m_tile_extent_idx;

CREATE INDEX soundings_vnsl_8m_tile_extent_idx
    ON soundings_vnsl_8m USING gist
    (tile_extent)
    TABLESPACE pg_default;

-- Index: soundings_vnsl_8m_tile_geom_idx

-- DROP INDEX soundings_vnsl_8m_tile_geom_idx;

CREATE INDEX soundings_vnsl_8m_tile_geom_idx
    ON soundings_vnsl_8m USING gist
    (tile_geom)
TABLESPACE pg_default;

-- Table: soundings_16m

-- DROP TABLE soundings_16m;

CREATE TABLE soundings_16m
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
    CONSTRAINT soundings_16m_pk PRIMARY KEY (id),
    CONSTRAINT enforce_out_db_rast CHECK (_raster_constraint_out_db(rast) = '{f,f,f,f,f}'::boolean[]),
    CONSTRAINT enforce_nodata_values_rast CHECK (_raster_constraint_nodata_values(rast) = '{340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000}'::numeric[]),
    CONSTRAINT enforce_pixel_types_rast CHECK (_raster_constraint_pixel_types(rast) = '{32BF,32BF,32BF,32BF,32BF}'::text[]),
    CONSTRAINT enforce_num_bands_rast CHECK (st_numbands(rast) = 5),
    CONSTRAINT enforce_scaley_rast CHECK (round(st_scaley(rast)::numeric, 10) = round(- 16::numeric, 10)),
    CONSTRAINT enforce_scalex_rast CHECK (round(st_scalex(rast)::numeric, 10) = round(16::numeric, 10)),
    CONSTRAINT enforce_srid_rast CHECK (st_srid(rast) = 3979)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

-- Index: soundings_16m_lower_sysperiod

-- DROP INDEX soundings_16m_lower_sysperiod;

CREATE INDEX soundings_16m_lower_sysperiod
    ON soundings_16m USING btree
    (lower(sys_period))
    TABLESPACE pg_default;

-- Index: soundings_16m_metadata_id

-- DROP INDEX soundings_16m_metadata_id;

CREATE INDEX soundings_16m_metadata_id
    ON soundings_16m USING btree
    (metadata_id COLLATE pg_catalog."default")
    TABLESPACE pg_default;

-- Index: soundings_16m_raster

-- DROP INDEX soundings_16m_raster;

CREATE INDEX soundings_16m_raster
    ON soundings_16m USING gist
    (st_convexhull(rast))
    TABLESPACE pg_default;

-- Index: soundings_16m_sysperiod

-- DROP INDEX soundings_16m_sysperiod;

CREATE INDEX soundings_16m_sysperiod
    ON soundings_16m USING gist
    (sys_period)
    TABLESPACE pg_default;

-- Index: soundings_16m_tile_extent_idx

-- DROP INDEX soundings_16m_tile_extent_idx;

CREATE INDEX soundings_16m_tile_extent_idx
    ON soundings_16m USING gist
    (tile_extent)
    TABLESPACE pg_default;

-- Index: soundings_16m_tile_geom_idx

-- DROP INDEX soundings_16m_tile_geom_idx;

CREATE INDEX soundings_16m_tile_geom_idx
    ON soundings_16m USING gist
    (tile_geom)
    TABLESPACE pg_default;
    
-- Table: soundings_vnsl_16m

-- DROP TABLE soundings_vnsl_16m;

CREATE TABLE soundings_vnsl_16m
(
    -- Inherited from table soundings_16m: id integer NOT NULL DEFAULT nextval('soundings_16m_id_seq'::regclass),
    -- Inherited from table soundings_16m: tile_id bigint,
    -- Inherited from table soundings_16m: rast raster,
    -- Inherited from table soundings_16m: resolution double precision,
    -- Inherited from table soundings_16m: filename text COLLATE pg_catalog."default",
    -- Inherited from table soundings_16m: sys_period tstzrange,
    -- Inherited from table soundings_16m: tile_extent geometry(Polygon),
    -- Inherited from table soundings_16m: tile_geom geometry(MultiPolygon),
    -- Inherited from table soundings_16m: metadata_id character varying(100) COLLATE pg_catalog."default",
    -- Inherited from table soundings_16m: shoal_geom geometry(MultiPolygon,3979),
    CONSTRAINT soundings_vnsl_16m_pkey PRIMARY KEY (id),
    CONSTRAINT enforce_same_alignment_rast CHECK (st_samealignment(rast, '0100000000000000000000304000000000000030C000000000209C39410000000000A0E9C0000000000000000000000000000000008B0F000001000100'::raster)),
    CONSTRAINT enforce_out_db_rast CHECK (_raster_constraint_out_db(rast) = '{f,f,f,f,f}'::boolean[]),
    CONSTRAINT enforce_nodata_values_rast CHECK (_raster_constraint_nodata_values(rast) = '{340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000}'::numeric[]),
    CONSTRAINT enforce_pixel_types_rast CHECK (_raster_constraint_pixel_types(rast) = '{32BF,32BF,32BF,32BF,32BF}'::text[]),
    CONSTRAINT enforce_num_bands_rast CHECK (st_numbands(rast) = 5),
    CONSTRAINT enforce_scaley_rast CHECK (round(st_scaley(rast)::numeric, 10) = round(- 16::numeric, 10)),
    CONSTRAINT enforce_scalex_rast CHECK (round(st_scalex(rast)::numeric, 10) = round(16::numeric, 10)),
    CONSTRAINT enforce_srid_rast CHECK (st_srid(rast) = 3979)
)
    INHERITS (soundings_16m)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

-- Index: soundings_vnsl_16m_lower_sysperiod

-- DROP INDEX soundings_vnsl_16m_lower_sysperiod;

CREATE INDEX soundings_vnsl_16m_lower_sysperiod
    ON soundings_vnsl_16m USING btree
    (lower(sys_period))
    TABLESPACE pg_default;

-- Index: soundings_vnsl_16m_metadata_id

-- DROP INDEX soundings_vnsl_16m_metadata_id;

CREATE INDEX soundings_vnsl_16m_metadata_id
    ON soundings_vnsl_16m USING btree
    (metadata_id COLLATE pg_catalog."default")
    TABLESPACE pg_default;

-- Index: soundings_vnsl_16m_raster

-- DROP INDEX soundings_vnsl_16m_raster;

CREATE INDEX soundings_vnsl_16m_raster
    ON soundings_vnsl_16m USING gist
    (st_convexhull(rast))
    TABLESPACE pg_default;

-- Index: soundings_vnsl_16m_sysperiod

-- DROP INDEX soundings_vnsl_16m_sysperiod;

CREATE INDEX soundings_vnsl_16m_sysperiod
    ON soundings_vnsl_16m USING gist
    (sys_period)
    TABLESPACE pg_default;

-- Index: soundings_vnsl_16m_tile_extent_idx

-- DROP INDEX soundings_vnsl_16m_tile_extent_idx;

CREATE INDEX soundings_vnsl_16m_tile_extent_idx
    ON soundings_vnsl_16m USING gist
    (tile_extent)
    TABLESPACE pg_default;

-- Index: soundings_vnsl_16m_tile_geom_idx

-- DROP INDEX soundings_vnsl_16m_tile_geom_idx;

CREATE INDEX soundings_vnsl_16m_tile_geom_idx
    ON soundings_vnsl_16m USING gist
    (tile_geom)
TABLESPACE pg_default;




CREATE FUNCTION partition_insert_trigger()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF 
AS $BODY$
BEGIN
IF ( NEW.resolution = 0.25  AND
 NEW.filename ~ E'^\\d{2}[a-z]{1}'  ) THEN
INSERT INTO soundings_vnsl_25cm VALUES (NEW.*);
raise notice '%',NEW.id;
raise notice '%',NEW.filename;
ELSIF ( NEW.resolution = 0.5 AND
 NEW.filename ~ E'^\\d{2}[a-z]{1}') THEN
INSERT INTO soundings_vnsl_50cm VALUES (NEW.*);
ELSIF ( NEW.resolution = 1 AND
 NEW.filename ~ E'^\\d{2}[a-z]{1}') THEN
INSERT INTO soundings_vnsl_1m VALUES (NEW.*);
ELSIF ( NEW.resolution = 2 AND
 NEW.filename ~ E'^\\d{2}[a-z]{1}') THEN
INSERT INTO soundings_vnsl_2m VALUES (NEW.*);
ELSIF ( NEW.resolution = 4 AND
  NEW.filename ~ E'^\\d{2}[a-z]{1}') THEN
INSERT INTO soundings_vnsl_4m VALUES (NEW.*);
ELSIF ( NEW.resolution = 8 AND
  NEW.filename ~ E'^\\d{2}[a-z]{1}') THEN
INSERT INTO soundings_vnsl_8m VALUES (NEW.*);
ELSIF ( NEW.resolution = 16 AND
 NEW.filename ~ E'^\\d{2}[a-z]{1}') THEN
INSERT INTO soundings_vnsl_16m VALUES (NEW.*);
elsIF ( NEW.resolution = 0.25 AND
  NEW.filename ~ E'^\\d{5}[a-z|_]{1}') THEN
INSERT INTO soundings_western_25cm VALUES (NEW.*);
ELSIF ( NEW.resolution = 0.5 AND
 NEW.filename ~ E'^\\d{5}[a-z|_]{1}') THEN
INSERT INTO soundings_western_50cm VALUES (NEW.*);
ELSIF ( NEW.resolution = 1 AND
  NEW.filename ~ E'^\\d{5}[a-z|_]{1}') THEN
INSERT INTO soundings_western_1m VALUES (NEW.*);
ELSIF ( NEW.resolution = 2 AND
  NEW.filename ~ E'^\\d{5}[a-z|_]{1}') THEN
INSERT INTO soundings_western_2m VALUES (NEW.*);
ELSIF ( NEW.resolution = 4 AND
  NEW.filename ~ E'^\\d{5}[a-z|_]{1}') THEN
INSERT INTO soundings_western_4m VALUES (NEW.*);
ELSIF ( NEW.resolution = 8 AND
 NEW.filename ~ E'^\\d{5}[a-z|_]{1}') THEN
INSERT INTO soundings_western_8m VALUES (NEW.*);
ELSIF ( NEW.resolution = 16 AND
  NEW.filename ~ E'^\\d{5}[a-z|_]{1}') THEN
INSERT INTO soundings_western_16m VALUES (NEW.*);ELSE
INSERT INTO soundings_error VALUES (NEW.*);
raise notice 'erreur %',NEW.resolution;
raise notice 'erreur %',NEW.filename;
END IF;
RETURN NULL;
END;
$BODY$;


CREATE TABLE soundings
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
    shoal_geom geometry(MultiPolygon,3979)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE TRIGGER partition_insert
    BEFORE INSERT
    ON soundings
    FOR EACH ROW
    EXECUTE PROCEDURE partition_insert_trigger();

CREATE TABLE  soundings_error
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
    CONSTRAINT  soundings_error_pk PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE TABLE public.metadata
(
    dunits text COLLATE pg_catalog."default",
    hordat text COLLATE pg_catalog."default",
    hunits text COLLATE pg_catalog."default",
    objnam text COLLATE pg_catalog."default" NOT NULL,
    surath text COLLATE pg_catalog."default",
    surend text COLLATE pg_catalog."default",
    sursta text COLLATE pg_catalog."default",
    surtyp text COLLATE pg_catalog."default",
    tecsou text COLLATE pg_catalog."default",
    verdat text COLLATE pg_catalog."default",
    ch_typ text COLLATE pg_catalog."default",
    client text COLLATE pg_catalog."default",
    cretim text COLLATE pg_catalog."default",
    glocat text COLLATE pg_catalog."default",
    hcosys text COLLATE pg_catalog."default",
    idprnt text COLLATE pg_catalog."default",
    km_end text COLLATE pg_catalog."default",
    kmstar text COLLATE pg_catalog."default",
    lwschm text COLLATE pg_catalog."default",
    modtim text COLLATE pg_catalog."default",
    planam text COLLATE pg_catalog."default",
    plocat text COLLATE pg_catalog."default",
    prjtyp text COLLATE pg_catalog."default",
    srcfil text COLLATE pg_catalog."default",
    srfcat text COLLATE pg_catalog."default",
    srfdsc text COLLATE pg_catalog."default",
    srfres text COLLATE pg_catalog."default",
    srftyp text COLLATE pg_catalog."default",
    sursso text COLLATE pg_catalog."default",
    uidcre text COLLATE pg_catalog."default",
    CONSTRAINT metadata_pkey PRIMARY KEY (objnam)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;