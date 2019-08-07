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