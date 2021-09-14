
-- ---------------------
-- Create a WIS schema
-- ---------------------

SET client_min_messages TO WARNING;
CREATE SCHEMA schema2rename;

-- ---------------------
-- PARTITIONED TRIGGER
-- ---------------------

CREATE FUNCTION schema2rename.wis_partition_insert()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
t_region text;
BEGIN
        SELECT region FROM wis.region_footprint  where st_intersects(new.tile_extent,geom) INTO t_region;
        --raise notice ' i: % : %', new.id, t_region ;
        IF t_region ='Atlantic' THEN
                IF ( NEW.resolution = 0.25 ) THEN
                        INSERT INTO schema2rename.soundings_atlantic_25cm VALUES (NEW.*);
                ELSIF ( NEW.resolution = 0.5 ) THEN
                        INSERT INTO schema2rename.soundings_atlantic_50cm VALUES (NEW.*);
                ELSIF ( NEW.resolution = 1 ) THEN
                        INSERT INTO schema2rename.soundings_atlantic_1m VALUES (NEW.*);
                ELSIF ( NEW.resolution = 2 ) THEN
                        INSERT INTO schema2rename.soundings_atlantic_2m VALUES (NEW.*);
                ELSIF ( NEW.resolution = 4 ) THEN
                        INSERT INTO schema2rename.soundings_atlantic_4m VALUES (NEW.*);
                ELSIF ( NEW.resolution = 8 ) THEN
                        INSERT INTO schema2rename.soundings_atlantic_8m VALUES (NEW.*);
                ELSIF ( NEW.resolution = 16 ) THEN
                        INSERT INTO schema2rename.soundings_atlantic_16m VALUES (NEW.*);
                END IF;
        ELSEIF t_region ='CA' THEN
                IF ( NEW.resolution = 0.25 ) THEN
                        INSERT INTO schema2rename.soundings_vnsl_25cm VALUES (NEW.*);
                ELSIF ( NEW.resolution = 0.5 ) THEN
                        INSERT INTO schema2rename.soundings_vnsl_50cm VALUES (NEW.*);
                ELSIF ( NEW.resolution = 1 ) THEN
                        INSERT INTO schema2rename.soundings_vnsl_1m VALUES (NEW.*);
                ELSIF ( NEW.resolution = 2 ) THEN
                        INSERT INTO schema2rename.soundings_vnsl_2m VALUES (NEW.*);
                ELSIF ( NEW.resolution = 4 ) THEN
                        INSERT INTO schema2rename.soundings_vnsl_4m VALUES (NEW.*);
                ELSIF ( NEW.resolution = 8 ) THEN
                        INSERT INTO schema2rename.soundings_vnsl_8m VALUES (NEW.*);
                ELSIF ( NEW.resolution = 16 ) THEN
                        INSERT INTO schema2rename.soundings_vnsl_16m VALUES (NEW.*);
                END IF;
        ELSEIF  t_region = 'Western' THEN
                IF ( NEW.resolution = 0.25 ) THEN
                        INSERT INTO schema2rename.soundings_western_25cm VALUES (NEW.*);
                ELSIF ( NEW.resolution = 0.5 ) THEN
                        INSERT INTO schema2rename.soundings_western_50cm VALUES (NEW.*);
                ELSIF ( NEW.resolution = 1 ) THEN
                        INSERT INTO schema2rename.soundings_western_1m VALUES (NEW.*);
                ELSIF ( NEW.resolution = 2 ) THEN
                        INSERT INTO schema2rename.soundings_western_2m VALUES (NEW.*);
                ELSIF ( NEW.resolution = 4 ) THEN
                        INSERT INTO schema2rename.soundings_western_4m VALUES (NEW.*);
                ELSIF ( NEW.resolution = 8 ) THEN
                        INSERT INTO schema2rename.soundings_western_8m VALUES (NEW.*);
                ELSIF ( NEW.resolution = 16 ) THEN
                        INSERT INTO schema2rename.soundings_western_16m VALUES (NEW.*);
                END IF;
        ELSE
                INSERT INTO schema2rename.soundings_no_region VALUES (NEW.*);
        END IF;
        RETURN NULL;
        exception when others then
                INSERT INTO schema2rename.soundings_error VALUES (NEW.*);
                insert into schema2rename.soundings_error_reason values(new.id, sqlerrm );
                raise notice ' % ', SQLERRM;
                RETURN NULL;
END;
$BODY$;

-- ---------------------
-- Util table
-- ---------------------

CREATE TABLE schema2rename.soundings_no_region(
    id serial,
    tile_id bigint,
    rast raster,
    resolution double precision,
    filename text COLLATE pg_catalog."default",
    sys_period tstzrange,
    tile_extent geometry(Polygon),
    tile_geom geometry(MultiPolygon),
    metadata_id character varying(100) COLLATE pg_catalog."default",
    shoal_geom geometry(MultiPolygon,3979)
);

CREATE TABLE schema2rename.sounding_age (
    year double precision,
    geom geometry(Polygon,3979)
);

CREATE TABLE schema2rename.sounding_age_year (
    geom geometry(MultiPolygon,3979),
    year double precision
);

CREATE TABLE schema2rename.soundings_error (
    id integer NOT NULL,
    tile_id bigint,
    rast raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent geometry(Polygon),
    tile_geom geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom geometry(MultiPolygon,3979)
);

-- ---------------------
-- Routing table
-- ---------------------
CREATE SEQUENCE schema2rename.soundings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE schema2rename.soundings (
    id integer DEFAULT nextval('schema2rename.soundings_id_seq'::regclass),
    tile_id bigint,
    rast raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent geometry(Polygon),
    tile_geom geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom geometry(MultiPolygon,3979)
);

-- add trigger to this table
CREATE TRIGGER partition_insert
    BEFORE INSERT
    ON schema2rename.soundings
    FOR EACH ROW
    EXECUTE PROCEDURE schema2rename.wis_partition_insert();

-- ---------------------
-- 25cm 
-- ---------------------

CREATE SEQUENCE schema2rename.soundings_25cm_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE schema2rename.soundings_25cm (
    id integer DEFAULT nextval('schema2rename.soundings_25cm_id_seq'::regclass),
    tile_id bigint,
    rast raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent geometry(Polygon),
    tile_geom geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom geometry(MultiPolygon,3979)
);

CREATE TABLE schema2rename.soundings_atlantic_25cm (
    id integer DEFAULT nextval('schema2rename.soundings_25cm_id_seq'::regclass),
    tile_id bigint,
    rast raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent geometry(Polygon),
    tile_geom geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom geometry(MultiPolygon,3979)
)
INHERITS (schema2rename.soundings_25cm);

CREATE TABLE schema2rename.soundings_western_25cm (
    id integer DEFAULT nextval('schema2rename.soundings_25cm_id_seq'::regclass),
    tile_id bigint,
    rast raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent geometry(Polygon),
    tile_geom geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom geometry(MultiPolygon,3979)
)
INHERITS (schema2rename.soundings_25cm);

CREATE TABLE schema2rename.soundings_vnsl_25cm (
    id integer DEFAULT nextval('schema2rename.soundings_25cm_id_seq'::regclass),
    tile_id bigint,
    rast raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent geometry(Polygon),
    tile_geom geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom geometry(MultiPolygon,3979)
)
INHERITS (schema2rename.soundings_25cm);

-- ---------------------
-- 50cm 
-- ---------------------
CREATE SEQUENCE schema2rename.soundings_50cm_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE schema2rename.soundings_50cm (
    id integer DEFAULT nextval('schema2rename.soundings_50cm_id_seq'::regclass),
    tile_id bigint,
    rast raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent geometry(Polygon),
    tile_geom geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom geometry(MultiPolygon,3979)
);

CREATE TABLE schema2rename.soundings_atlantic_50cm (
    id integer DEFAULT nextval('schema2rename.soundings_50cm_id_seq'::regclass),
    tile_id bigint,
    rast raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent geometry(Polygon),
    tile_geom geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom geometry(MultiPolygon,3979)
)
INHERITS (schema2rename.soundings_50cm);

CREATE TABLE schema2rename.soundings_vnsl_50cm (
    id integer DEFAULT nextval('schema2rename.soundings_50cm_id_seq'::regclass),
    tile_id bigint,
    rast raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent geometry(Polygon),
    tile_geom geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom geometry(MultiPolygon,3979)
)
INHERITS (schema2rename.soundings_50cm);

CREATE TABLE schema2rename.soundings_western_50cm (
    id integer DEFAULT nextval('schema2rename.soundings_50cm_id_seq'::regclass),
    tile_id bigint,
    rast raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent geometry(Polygon),
    tile_geom geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom geometry(MultiPolygon,3979)
)
INHERITS (schema2rename.soundings_50cm);

-- ---------------------
-- 1m 
-- ---------------------

CREATE SEQUENCE schema2rename.soundings_1m_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE schema2rename.soundings_1m (
    id integer DEFAULT nextval('schema2rename.soundings_1m_id_seq'::regclass),
    tile_id bigint,
    rast raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent geometry(Polygon),
    tile_geom geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom geometry(MultiPolygon,3979)
);

CREATE TABLE schema2rename.soundings_vnsl_1m (
    id integer DEFAULT nextval('schema2rename.soundings_1m_id_seq'::regclass),
    tile_id bigint,
    rast raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent geometry(Polygon),
    tile_geom geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom geometry(MultiPolygon,3979)
)
INHERITS (schema2rename.soundings_1m);

CREATE TABLE schema2rename.soundings_atlantic_1m (
    id integer DEFAULT nextval('schema2rename.soundings_1m_id_seq'::regclass),
    tile_id bigint,
    rast raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent geometry(Polygon),
    tile_geom geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom geometry(MultiPolygon,3979)
)
INHERITS (schema2rename.soundings_1m);

CREATE TABLE schema2rename.soundings_western_1m (
    id integer DEFAULT nextval('schema2rename.soundings_1m_id_seq'::regclass),
    tile_id bigint,
    rast raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent geometry(Polygon),
    tile_geom geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom geometry(MultiPolygon,3979)
)
INHERITS (schema2rename.soundings_1m);

-- ---------------------
-- 2m 
-- ---------------------

CREATE SEQUENCE schema2rename.soundings_2m_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE schema2rename.soundings_2m (
    id integer DEFAULT nextval('schema2rename.soundings_2m_id_seq'::regclass),
    tile_id bigint,
    rast raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent geometry(Polygon),
    tile_geom geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom geometry(MultiPolygon,3979)
);

CREATE TABLE schema2rename.soundings_atlantic_2m (
    id integer DEFAULT nextval('schema2rename.soundings_2m_id_seq'::regclass),
    tile_id bigint,
    rast raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent geometry(Polygon),
    tile_geom geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom geometry(MultiPolygon,3979)
)
INHERITS (schema2rename.soundings_2m);

CREATE TABLE schema2rename.soundings_vnsl_2m (
    id integer DEFAULT nextval('schema2rename.soundings_2m_id_seq'::regclass),
    tile_id bigint,
    rast raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent geometry(Polygon),
    tile_geom geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom geometry(MultiPolygon,3979)
)
INHERITS (schema2rename.soundings_2m);

CREATE TABLE schema2rename.soundings_western_2m (
    id integer DEFAULT nextval('schema2rename.soundings_2m_id_seq'::regclass),
    tile_id bigint,
    rast raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent geometry(Polygon),
    tile_geom geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom geometry(MultiPolygon,3979)
)
INHERITS (schema2rename.soundings_2m);

-- ---------------------
-- 4m 
-- ---------------------

CREATE SEQUENCE schema2rename.soundings_4m_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE schema2rename.soundings_4m (
    id integer DEFAULT nextval('schema2rename.soundings_4m_id_seq'::regclass),
    tile_id bigint,
    rast raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent geometry(Polygon),
    tile_geom geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom geometry(MultiPolygon,3979)
);

CREATE TABLE schema2rename.soundings_atlantic_4m (
    id integer DEFAULT nextval('schema2rename.soundings_4m_id_seq'::regclass),
    tile_id bigint,
    rast raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent geometry(Polygon),
    tile_geom geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom geometry(MultiPolygon,3979)
)
INHERITS (schema2rename.soundings_4m);

CREATE TABLE schema2rename.soundings_vnsl_4m (
    id integer DEFAULT nextval('schema2rename.soundings_4m_id_seq'::regclass),
    tile_id bigint,
    rast raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent geometry(Polygon),
    tile_geom geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom geometry(MultiPolygon,3979)
)
INHERITS (schema2rename.soundings_4m);

CREATE TABLE schema2rename.soundings_western_4m (
    id integer DEFAULT nextval('schema2rename.soundings_4m_id_seq'::regclass),
    tile_id bigint,
    rast raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent geometry(Polygon),
    tile_geom geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom geometry(MultiPolygon,3979)
)
INHERITS (schema2rename.soundings_4m);

-- ---------------------
-- 8m 
-- ---------------------

CREATE SEQUENCE schema2rename.soundings_8m_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE schema2rename.soundings_8m (
    id integer DEFAULT nextval('schema2rename.soundings_8m_id_seq'::regclass),
    tile_id bigint,
    rast raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent geometry(Polygon),
    tile_geom geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom geometry(MultiPolygon,3979)
);


CREATE TABLE schema2rename.soundings_atlantic_8m (
    id integer DEFAULT nextval('schema2rename.soundings_8m_id_seq'::regclass),
    tile_id bigint,
    rast raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent geometry(Polygon),
    tile_geom geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom geometry(MultiPolygon,3979)
)
INHERITS (schema2rename.soundings_8m);

CREATE TABLE schema2rename.soundings_vnsl_8m (
    id integer DEFAULT nextval('schema2rename.soundings_8m_id_seq'::regclass),
    tile_id bigint,
    rast raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent geometry(Polygon),
    tile_geom geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom geometry(MultiPolygon,3979)
)
INHERITS (schema2rename.soundings_8m);

CREATE TABLE schema2rename.soundings_western_8m (
    id integer DEFAULT nextval('schema2rename.soundings_8m_id_seq'::regclass),
    tile_id bigint,
    rast raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent geometry(Polygon),
    tile_geom geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom geometry(MultiPolygon,3979)
)
INHERITS (schema2rename.soundings_8m);

-- ---------------------
-- 16m 
-- ---------------------
CREATE SEQUENCE schema2rename.soundings_16m_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE schema2rename.soundings_16m (
    id integer DEFAULT nextval('schema2rename.soundings_16m_id_seq'::regclass),
    tile_id bigint,
    rast raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent geometry(Polygon),
    tile_geom geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom geometry(MultiPolygon,3979)
);

CREATE TABLE schema2rename.soundings_vnsl_16m (
    id integer DEFAULT nextval('schema2rename.soundings_16m_id_seq'::regclass),
    tile_id bigint,
    rast raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent geometry(Polygon),
    tile_geom geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom geometry(MultiPolygon,3979)
)
INHERITS (schema2rename.soundings_16m);

CREATE TABLE schema2rename.soundings_atlantic_16m (
    id integer DEFAULT nextval('schema2rename.soundings_16m_id_seq'::regclass),
    tile_id bigint,
    rast raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent geometry(Polygon),
    tile_geom geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom geometry(MultiPolygon,3979)
)
INHERITS (schema2rename.soundings_16m);

CREATE TABLE schema2rename.soundings_western_16m (
    id integer DEFAULT nextval('schema2rename.soundings_16m_id_seq'::regclass),
    tile_id bigint,
    rast raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent geometry(Polygon),
    tile_geom geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom geometry(MultiPolygon,3979)
)
INHERITS (schema2rename.soundings_16m);

-- -----------------
-- PRIMARY KEY
-- -----------------
ALTER TABLE ONLY schema2rename.soundings_25cm ADD CONSTRAINT soundings_25cm_pk PRIMARY KEY (id);
ALTER TABLE ONLY schema2rename.soundings_50cm ADD CONSTRAINT soundings_50cm_pk PRIMARY KEY (id);
ALTER TABLE ONLY schema2rename.soundings_1m ADD CONSTRAINT soundings_1m_pk PRIMARY KEY (id);
ALTER TABLE ONLY schema2rename.soundings_2m  ADD CONSTRAINT soundings_2m_pk PRIMARY KEY (id);
ALTER TABLE ONLY schema2rename.soundings_4m ADD CONSTRAINT soundings_4m_pk PRIMARY KEY (id);
ALTER TABLE ONLY schema2rename.soundings_8m ADD CONSTRAINT soundings_8m_pk PRIMARY KEY (id);
ALTER TABLE ONLY schema2rename.soundings_16m ADD CONSTRAINT soundings_16m_pk PRIMARY KEY (id);

ALTER TABLE ONLY schema2rename.soundings_atlantic_25cm ADD CONSTRAINT soundings_atlantic_25cm_pkey PRIMARY KEY (id);
ALTER TABLE ONLY schema2rename.soundings_atlantic_50cm ADD CONSTRAINT soundings_atlantic_50cm_pkey PRIMARY KEY (id);
ALTER TABLE ONLY schema2rename.soundings_atlantic_1m ADD CONSTRAINT soundings_atlantic_1m_pkey PRIMARY KEY (id);
ALTER TABLE ONLY schema2rename.soundings_atlantic_2m ADD CONSTRAINT soundings_atlantic_2m_pkey PRIMARY KEY (id);
ALTER TABLE ONLY schema2rename.soundings_atlantic_4m ADD CONSTRAINT soundings_atlantic_4m_pkey PRIMARY KEY (id);
ALTER TABLE ONLY schema2rename.soundings_atlantic_8m ADD CONSTRAINT soundings_atlantic_8m_pkey PRIMARY KEY (id);
ALTER TABLE ONLY schema2rename.soundings_atlantic_16m ADD CONSTRAINT soundings_atlantic_16m_pkey PRIMARY KEY (id);

ALTER TABLE ONLY schema2rename.soundings_vnsl_25cm ADD CONSTRAINT soundings_vnsl_25cm_pkey PRIMARY KEY (id);
ALTER TABLE ONLY schema2rename.soundings_vnsl_50cm ADD CONSTRAINT soundings_vnsl_50cm_pkey PRIMARY KEY (id);
ALTER TABLE ONLY schema2rename.soundings_vnsl_1m ADD CONSTRAINT soundings_vnsl_1m_pkey PRIMARY KEY (id);
ALTER TABLE ONLY schema2rename.soundings_vnsl_2m ADD CONSTRAINT soundings_vnsl_2m_pkey PRIMARY KEY (id);
ALTER TABLE ONLY schema2rename.soundings_vnsl_4m ADD CONSTRAINT soundings_vnsl_4m_pkey PRIMARY KEY (id);
ALTER TABLE ONLY schema2rename.soundings_vnsl_8m ADD CONSTRAINT soundings_vnsl_8m_pkey PRIMARY KEY (id);
ALTER TABLE ONLY schema2rename.soundings_vnsl_16m ADD CONSTRAINT soundings_vnsl_16m_pkey PRIMARY KEY (id);

ALTER TABLE ONLY schema2rename.soundings_western_25cm ADD CONSTRAINT soundings_western_25cm_pkey PRIMARY KEY (id);
ALTER TABLE ONLY schema2rename.soundings_western_50cm ADD CONSTRAINT soundings_western_50cm_pkey PRIMARY KEY (id);
ALTER TABLE ONLY schema2rename.soundings_western_1m ADD CONSTRAINT soundings_western_1m_pkey PRIMARY KEY (id);
ALTER TABLE ONLY schema2rename.soundings_western_2m ADD CONSTRAINT soundings_western_2m_pkey PRIMARY KEY (id);
ALTER TABLE ONLY schema2rename.soundings_western_4m ADD CONSTRAINT soundings_western_4m_pkey PRIMARY KEY (id);
ALTER TABLE ONLY schema2rename.soundings_western_8m ADD CONSTRAINT soundings_western_8m_pkey PRIMARY KEY (id);
ALTER TABLE ONLY schema2rename.soundings_western_16m ADD CONSTRAINT soundings_western_16m_pkey PRIMARY KEY (id);

ALTER TABLE ONLY schema2rename.soundings_error ADD CONSTRAINT soundings_error_pk PRIMARY KEY (id);


-- -----------------
-- INDEX
-- -----------------
CREATE INDEX soundings_25cm_lower_sysperiod ON schema2rename.soundings_25cm USING btree (lower(sys_period));
CREATE INDEX soundings_25cm_metadata_id ON schema2rename.soundings_25cm USING btree (metadata_id);
CREATE INDEX soundings_25cm_raster ON schema2rename.soundings_25cm USING gist (st_convexhull(rast));
CREATE INDEX soundings_25cm_sysperiod ON schema2rename.soundings_25cm USING gist (sys_period);
CREATE INDEX soundings_25cm_tile_extent_idx ON schema2rename.soundings_25cm USING gist (tile_extent);
CREATE INDEX soundings_25cm_tile_geom_idx ON schema2rename.soundings_25cm USING gist (tile_geom);
CREATE INDEX soundings_atlantic_25cm_lower_sysperiod ON schema2rename.soundings_atlantic_25cm USING btree (lower(sys_period));
CREATE INDEX soundings_atlantic_25cm_metadata_id ON schema2rename.soundings_atlantic_25cm USING btree (metadata_id);
CREATE INDEX soundings_atlantic_25cm_raster ON schema2rename.soundings_atlantic_25cm USING gist (st_convexhull(rast));
CREATE INDEX soundings_atlantic_25cm_sysperiod ON schema2rename.soundings_atlantic_25cm USING gist (sys_period);
CREATE INDEX soundings_atlantic_25cm_tile_extent_idx ON schema2rename.soundings_atlantic_25cm USING gist (tile_extent);
CREATE INDEX soundings_atlantic_25cm_tile_geom_idx ON schema2rename.soundings_atlantic_25cm USING gist (tile_geom);
CREATE INDEX soundings_vnsl_25cm_lower_sysperiod ON schema2rename.soundings_vnsl_25cm USING btree (lower(sys_period));
CREATE INDEX soundings_vnsl_25cm_metadata_id ON schema2rename.soundings_vnsl_25cm USING btree (metadata_id);
CREATE INDEX soundings_vnsl_25cm_raster ON schema2rename.soundings_vnsl_25cm USING gist (st_convexhull(rast));
CREATE INDEX soundings_vnsl_25cm_sysperiod ON schema2rename.soundings_vnsl_25cm USING gist (sys_period);
CREATE INDEX soundings_vnsl_25cm_tile_extent_idx ON schema2rename.soundings_vnsl_25cm USING gist (tile_extent);
CREATE INDEX soundings_vnsl_25cm_tile_geom_idx ON schema2rename.soundings_vnsl_25cm USING gist (tile_geom);
CREATE INDEX soundings_western_25cm_lower_sysperiod ON schema2rename.soundings_western_25cm USING btree (lower(sys_period));
CREATE INDEX soundings_western_25cm_metadata_id ON schema2rename.soundings_western_25cm USING btree (metadata_id);
CREATE INDEX soundings_western_25cm_raster ON schema2rename.soundings_western_25cm USING gist (st_convexhull(rast));
CREATE INDEX soundings_western_25cm_sysperiod ON schema2rename.soundings_western_25cm USING gist (sys_period);
CREATE INDEX soundings_western_25cm_tile_extent_idx ON schema2rename.soundings_western_25cm USING gist (tile_extent);
CREATE INDEX soundings_western_25cm_tile_geom_idx ON schema2rename.soundings_western_25cm USING gist (tile_geom);

CREATE INDEX soundings_50cm_lower_sysperiod ON schema2rename.soundings_50cm USING btree (lower(sys_period));
CREATE INDEX soundings_50cm_metadata_id ON schema2rename.soundings_50cm USING btree (metadata_id);
CREATE INDEX soundings_50cm_raster ON schema2rename.soundings_50cm USING gist (st_convexhull(rast));
CREATE INDEX soundings_50cm_sysperiod ON schema2rename.soundings_50cm USING gist (sys_period);
CREATE INDEX soundings_50cm_tile_extent_idx ON schema2rename.soundings_50cm USING gist (tile_extent);
CREATE INDEX soundings_50cm_tile_geom_idx ON schema2rename.soundings_50cm USING gist (tile_geom);
CREATE INDEX soundings_atlantic_50cm_lower_sysperiod ON schema2rename.soundings_atlantic_50cm USING btree (lower(sys_period));
CREATE INDEX soundings_atlantic_50cm_metadata_id ON schema2rename.soundings_atlantic_50cm USING btree (metadata_id);
CREATE INDEX soundings_atlantic_50cm_raster ON schema2rename.soundings_atlantic_50cm USING gist (st_convexhull(rast));
CREATE INDEX soundings_atlantic_50cm_sysperiod ON schema2rename.soundings_atlantic_50cm USING gist (sys_period);
CREATE INDEX soundings_atlantic_50cm_tile_extent_idx ON schema2rename.soundings_atlantic_50cm USING gist (tile_extent);
CREATE INDEX soundings_atlantic_50cm_tile_geom_idx ON schema2rename.soundings_atlantic_50cm USING gist (tile_geom);
CREATE INDEX soundings_vnsl_50cm_lower_sysperiod ON schema2rename.soundings_vnsl_50cm USING btree (lower(sys_period));
CREATE INDEX soundings_vnsl_50cm_metadata_id ON schema2rename.soundings_vnsl_50cm USING btree (metadata_id);
CREATE INDEX soundings_vnsl_50cm_raster ON schema2rename.soundings_vnsl_50cm USING gist (st_convexhull(rast));
CREATE INDEX soundings_vnsl_50cm_sysperiod ON schema2rename.soundings_vnsl_50cm USING gist (sys_period);
CREATE INDEX soundings_vnsl_50cm_tile_extent_idx ON schema2rename.soundings_vnsl_50cm USING gist (tile_extent);
CREATE INDEX soundings_vnsl_50cm_tile_geom_idx ON schema2rename.soundings_vnsl_50cm USING gist (tile_geom);
CREATE INDEX soundings_western_50cm_lower_sysperiod ON schema2rename.soundings_western_50cm USING btree (lower(sys_period));
CREATE INDEX soundings_western_50cm_metadata_id ON schema2rename.soundings_western_50cm USING btree (metadata_id);
CREATE INDEX soundings_western_50cm_raster ON schema2rename.soundings_western_50cm USING gist (st_convexhull(rast));
CREATE INDEX soundings_western_50cm_sysperiod ON schema2rename.soundings_western_50cm USING gist (sys_period);
CREATE INDEX soundings_western_50cm_tile_extent_idx ON schema2rename.soundings_western_50cm USING gist (tile_extent);
CREATE INDEX soundings_western_50cm_tile_geom_idx ON schema2rename.soundings_western_50cm USING gist (tile_geom);

CREATE INDEX soundings_1m_lower_sysperiod ON schema2rename.soundings_1m USING btree (lower(sys_period));
CREATE INDEX soundings_1m_metadata_id ON schema2rename.soundings_1m USING btree (metadata_id);
CREATE INDEX soundings_1m_raster ON schema2rename.soundings_1m USING gist (st_convexhull(rast));
CREATE INDEX soundings_1m_sysperiod ON schema2rename.soundings_1m USING gist (sys_period);
CREATE INDEX soundings_1m_tile_extent_idx ON schema2rename.soundings_1m USING gist (tile_extent);
CREATE INDEX soundings_1m_tile_geom_idx ON schema2rename.soundings_1m USING gist (tile_geom);
CREATE INDEX soundings_atlantic_1m_lower_sysperiod ON schema2rename.soundings_atlantic_1m USING btree (lower(sys_period));
CREATE INDEX soundings_atlantic_1m_metadata_id ON schema2rename.soundings_atlantic_1m USING btree (metadata_id);
CREATE INDEX soundings_atlantic_1m_raster ON schema2rename.soundings_atlantic_1m USING gist (st_convexhull(rast));
CREATE INDEX soundings_atlantic_1m_sysperiod ON schema2rename.soundings_atlantic_1m USING gist (sys_period);
CREATE INDEX soundings_atlantic_1m_tile_extent_idx ON schema2rename.soundings_atlantic_1m USING gist (tile_extent);
CREATE INDEX soundings_atlantic_1m_tile_geom_idx ON schema2rename.soundings_atlantic_1m USING gist (tile_geom);
CREATE INDEX soundings_vnsl_1m_lower_sysperiod ON schema2rename.soundings_vnsl_1m USING btree (lower(sys_period));
CREATE INDEX soundings_vnsl_1m_metadata_id ON schema2rename.soundings_vnsl_1m USING btree (metadata_id);
CREATE INDEX soundings_vnsl_1m_raster ON schema2rename.soundings_vnsl_1m USING gist (st_convexhull(rast));
CREATE INDEX soundings_vnsl_1m_sysperiod ON schema2rename.soundings_vnsl_1m USING gist (sys_period);
CREATE INDEX soundings_vnsl_1m_tile_extent_idx ON schema2rename.soundings_vnsl_1m USING gist (tile_extent);
CREATE INDEX soundings_vnsl_1m_tile_geom_idx ON schema2rename.soundings_vnsl_1m USING gist (tile_geom);
CREATE INDEX soundings_western_1m_lower_sysperiod ON schema2rename.soundings_western_1m USING btree (lower(sys_period));
CREATE INDEX soundings_western_1m_metadata_id ON schema2rename.soundings_western_1m USING btree (metadata_id);
CREATE INDEX soundings_western_1m_raster ON schema2rename.soundings_western_1m USING gist (st_convexhull(rast));
CREATE INDEX soundings_western_1m_sysperiod ON schema2rename.soundings_western_1m USING gist (sys_period);
CREATE INDEX soundings_western_1m_tile_extent_idx ON schema2rename.soundings_western_1m USING gist (tile_extent);
CREATE INDEX soundings_western_1m_tile_geom_idx ON schema2rename.soundings_western_1m USING gist (tile_geom);

CREATE INDEX soundings_2m_lower_sysperiod ON schema2rename.soundings_2m USING btree (lower(sys_period));
CREATE INDEX soundings_2m_metadata_id ON schema2rename.soundings_2m USING btree (metadata_id);
CREATE INDEX soundings_2m_raster ON schema2rename.soundings_2m USING gist (st_convexhull(rast));
CREATE INDEX soundings_2m_sysperiod ON schema2rename.soundings_2m USING gist (sys_period);
CREATE INDEX soundings_2m_tile_extent_idx ON schema2rename.soundings_2m USING gist (tile_extent);
CREATE INDEX soundings_2m_tile_geom_idx ON schema2rename.soundings_2m USING gist (tile_geom);
CREATE INDEX soundings_atlantic_2m_lower_sysperiod ON schema2rename.soundings_atlantic_2m USING btree (lower(sys_period));
CREATE INDEX soundings_atlantic_2m_metadata_id ON schema2rename.soundings_atlantic_2m USING btree (metadata_id);
CREATE INDEX soundings_atlantic_2m_raster ON schema2rename.soundings_atlantic_2m USING gist (st_convexhull(rast));
CREATE INDEX soundings_atlantic_2m_sysperiod ON schema2rename.soundings_atlantic_2m USING gist (sys_period);
CREATE INDEX soundings_atlantic_2m_tile_extent_idx ON schema2rename.soundings_atlantic_2m USING gist (tile_extent);
CREATE INDEX soundings_atlantic_2m_tile_geom_idx ON schema2rename.soundings_atlantic_2m USING gist (tile_geom);
CREATE INDEX soundings_vnsl_2m_lower_sysperiod ON schema2rename.soundings_vnsl_2m USING btree (lower(sys_period));
CREATE INDEX soundings_vnsl_2m_metadata_id ON schema2rename.soundings_vnsl_2m USING btree (metadata_id);
CREATE INDEX soundings_vnsl_2m_raster ON schema2rename.soundings_vnsl_2m USING gist (st_convexhull(rast));
CREATE INDEX soundings_vnsl_2m_sysperiod ON schema2rename.soundings_vnsl_2m USING gist (sys_period);
CREATE INDEX soundings_vnsl_2m_tile_extent_idx ON schema2rename.soundings_vnsl_2m USING gist (tile_extent);
CREATE INDEX soundings_vnsl_2m_tile_geom_idx ON schema2rename.soundings_vnsl_2m USING gist (tile_geom);
CREATE INDEX soundings_western_2m_lower_sysperiod ON schema2rename.soundings_western_2m USING btree (lower(sys_period));
CREATE INDEX soundings_western_2m_metadata_id ON schema2rename.soundings_western_2m USING btree (metadata_id);
CREATE INDEX soundings_western_2m_raster ON schema2rename.soundings_western_2m USING gist (st_convexhull(rast));
CREATE INDEX soundings_western_2m_sysperiod ON schema2rename.soundings_western_2m USING gist (sys_period);
CREATE INDEX soundings_western_2m_tile_extent_idx ON schema2rename.soundings_western_2m USING gist (tile_extent);
CREATE INDEX soundings_western_2m_tile_geom_idx ON schema2rename.soundings_western_2m USING gist (tile_geom);

CREATE INDEX soundings_4m_lower_sysperiod ON schema2rename.soundings_4m USING btree (lower(sys_period));
CREATE INDEX soundings_4m_metadata_id ON schema2rename.soundings_4m USING btree (metadata_id);
CREATE INDEX soundings_4m_raster ON schema2rename.soundings_4m USING gist (st_convexhull(rast));
CREATE INDEX soundings_4m_sysperiod ON schema2rename.soundings_4m USING gist (sys_period);
CREATE INDEX soundings_4m_tile_extent_idx ON schema2rename.soundings_4m USING gist (tile_extent);
CREATE INDEX soundings_4m_tile_geom_idx ON schema2rename.soundings_4m USING gist (tile_geom);
CREATE INDEX soundings_atlantic_4m_lower_sysperiod ON schema2rename.soundings_atlantic_4m USING btree (lower(sys_period));
CREATE INDEX soundings_atlantic_4m_metadata_id ON schema2rename.soundings_atlantic_4m USING btree (metadata_id);
CREATE INDEX soundings_atlantic_4m_raster ON schema2rename.soundings_atlantic_4m USING gist (st_convexhull(rast));
CREATE INDEX soundings_atlantic_4m_sysperiod ON schema2rename.soundings_atlantic_4m USING gist (sys_period);
CREATE INDEX soundings_atlantic_4m_tile_extent_idx ON schema2rename.soundings_atlantic_4m USING gist (tile_extent);
CREATE INDEX soundings_atlantic_4m_tile_geom_idx ON schema2rename.soundings_atlantic_4m USING gist (tile_geom);
CREATE INDEX soundings_vnsl_4m_lower_sysperiod ON schema2rename.soundings_vnsl_4m USING btree (lower(sys_period));
CREATE INDEX soundings_vnsl_4m_metadata_id ON schema2rename.soundings_vnsl_4m USING btree (metadata_id);
CREATE INDEX soundings_vnsl_4m_raster ON schema2rename.soundings_vnsl_4m USING gist (st_convexhull(rast));
CREATE INDEX soundings_vnsl_4m_sysperiod ON schema2rename.soundings_vnsl_4m USING gist (sys_period);
CREATE INDEX soundings_vnsl_4m_tile_extent_idx ON schema2rename.soundings_vnsl_4m USING gist (tile_extent);
CREATE INDEX soundings_vnsl_4m_tile_geom_idx ON schema2rename.soundings_vnsl_4m USING gist (tile_geom);
CREATE INDEX soundings_western_4m_lower_sysperiod ON schema2rename.soundings_western_4m USING btree (lower(sys_period));
CREATE INDEX soundings_western_4m_metadata_id ON schema2rename.soundings_western_4m USING btree (metadata_id);
CREATE INDEX soundings_western_4m_raster ON schema2rename.soundings_western_4m USING gist (st_convexhull(rast));
CREATE INDEX soundings_western_4m_sysperiod ON schema2rename.soundings_western_4m USING gist (sys_period);
CREATE INDEX soundings_western_4m_tile_extent_idx ON schema2rename.soundings_western_4m USING gist (tile_extent);
CREATE INDEX soundings_western_4m_tile_geom_idx ON schema2rename.soundings_western_4m USING gist (tile_geom);

CREATE INDEX soundings_8m_lower_sysperiod ON schema2rename.soundings_8m USING btree (lower(sys_period));
CREATE INDEX soundings_8m_metadata_id ON schema2rename.soundings_8m USING btree (metadata_id);
CREATE INDEX soundings_8m_raster ON schema2rename.soundings_8m USING gist (st_convexhull(rast));
CREATE INDEX soundings_8m_sysperiod ON schema2rename.soundings_8m USING gist (sys_period);
CREATE INDEX soundings_8m_tile_extent_idx ON schema2rename.soundings_8m USING gist (tile_extent);
CREATE INDEX soundings_8m_tile_geom_idx ON schema2rename.soundings_8m USING gist (tile_geom);
CREATE INDEX soundings_atlantic_8m_lower_sysperiod ON schema2rename.soundings_atlantic_8m USING btree (lower(sys_period));
CREATE INDEX soundings_atlantic_8m_metadata_id ON schema2rename.soundings_atlantic_8m USING btree (metadata_id);
CREATE INDEX soundings_atlantic_8m_raster ON schema2rename.soundings_atlantic_8m USING gist (st_convexhull(rast));
CREATE INDEX soundings_atlantic_8m_sysperiod ON schema2rename.soundings_atlantic_8m USING gist (sys_period);
CREATE INDEX soundings_atlantic_8m_tile_extent_idx ON schema2rename.soundings_atlantic_8m USING gist (tile_extent);
CREATE INDEX soundings_atlantic_8m_tile_geom_idx ON schema2rename.soundings_atlantic_8m USING gist (tile_geom);
CREATE INDEX soundings_vnsl_8m_lower_sysperiod ON schema2rename.soundings_vnsl_8m USING btree (lower(sys_period));
CREATE INDEX soundings_vnsl_8m_metadata_id ON schema2rename.soundings_vnsl_8m USING btree (metadata_id);
CREATE INDEX soundings_vnsl_8m_raster ON schema2rename.soundings_vnsl_8m USING gist (st_convexhull(rast));
CREATE INDEX soundings_vnsl_8m_sysperiod ON schema2rename.soundings_vnsl_8m USING gist (sys_period);
CREATE INDEX soundings_vnsl_8m_tile_extent_idx ON schema2rename.soundings_vnsl_8m USING gist (tile_extent);
CREATE INDEX soundings_vnsl_8m_tile_geom_idx ON schema2rename.soundings_vnsl_8m USING gist (tile_geom);
CREATE INDEX soundings_western_8m_lower_sysperiod ON schema2rename.soundings_western_8m USING btree (lower(sys_period));
CREATE INDEX soundings_western_8m_metadata_id ON schema2rename.soundings_western_8m USING btree (metadata_id);
CREATE INDEX soundings_western_8m_raster ON schema2rename.soundings_western_8m USING gist (st_convexhull(rast));
CREATE INDEX soundings_western_8m_sysperiod ON schema2rename.soundings_western_8m USING gist (sys_period);
CREATE INDEX soundings_western_8m_tile_extent_idx ON schema2rename.soundings_western_8m USING gist (tile_extent);
CREATE INDEX soundings_western_8m_tile_geom_idx ON schema2rename.soundings_western_8m USING gist (tile_geom);

CREATE INDEX soundings_16m_lower_sysperiod ON schema2rename.soundings_16m USING btree (lower(sys_period));
CREATE INDEX soundings_16m_metadata_id ON schema2rename.soundings_16m USING btree (metadata_id);
CREATE INDEX soundings_16m_raster ON schema2rename.soundings_16m USING gist (st_convexhull(rast));
CREATE INDEX soundings_16m_sysperiod ON schema2rename.soundings_16m USING gist (sys_period);
CREATE INDEX soundings_16m_tile_extent_idx ON schema2rename.soundings_16m USING gist (tile_extent);
CREATE INDEX soundings_16m_tile_geom_idx ON schema2rename.soundings_16m USING gist (tile_geom);
CREATE INDEX soundings_atlantic_16m_lower_sysperiod ON schema2rename.soundings_atlantic_16m USING btree (lower(sys_period));
CREATE INDEX soundings_atlantic_16m_metadata_id ON schema2rename.soundings_atlantic_16m USING btree (metadata_id);
CREATE INDEX soundings_atlantic_16m_raster ON schema2rename.soundings_atlantic_16m USING gist (st_convexhull(rast));
CREATE INDEX soundings_atlantic_16m_sysperiod ON schema2rename.soundings_atlantic_16m USING gist (sys_period);
CREATE INDEX soundings_atlantic_16m_tile_extent_idx ON schema2rename.soundings_atlantic_16m USING gist (tile_extent);
CREATE INDEX soundings_atlantic_16m_tile_geom_idx ON schema2rename.soundings_atlantic_16m USING gist (tile_geom);
CREATE INDEX soundings_vnsl_16m_lower_sysperiod ON schema2rename.soundings_vnsl_16m USING btree (lower(sys_period));
CREATE INDEX soundings_vnsl_16m_metadata_id ON schema2rename.soundings_vnsl_16m USING btree (metadata_id);
CREATE INDEX soundings_vnsl_16m_raster ON schema2rename.soundings_vnsl_16m USING gist (st_convexhull(rast));
CREATE INDEX soundings_vnsl_16m_sysperiod ON schema2rename.soundings_vnsl_16m USING gist (sys_period);
CREATE INDEX soundings_vnsl_16m_tile_extent_idx ON schema2rename.soundings_vnsl_16m USING gist (tile_extent);
CREATE INDEX soundings_vnsl_16m_tile_geom_idx ON schema2rename.soundings_vnsl_16m USING gist (tile_geom);
CREATE INDEX soundings_western_16m_lower_sysperiod ON schema2rename.soundings_western_16m USING btree (lower(sys_period));
CREATE INDEX soundings_western_16m_metadata_id ON schema2rename.soundings_western_16m USING btree (metadata_id);
CREATE INDEX soundings_western_16m_raster ON schema2rename.soundings_western_16m USING gist (st_convexhull(rast));
CREATE INDEX soundings_western_16m_sysperiod ON schema2rename.soundings_western_16m USING gist (sys_period);
CREATE INDEX soundings_western_16m_tile_extent_idx ON schema2rename.soundings_western_16m USING gist (tile_extent);
CREATE INDEX soundings_western_16m_tile_geom_idx ON schema2rename.soundings_western_16m USING gist (tile_geom);

CREATE INDEX sounding_age_geom_idx ON schema2rename.sounding_age USING gist (geom);
CREATE INDEX sounding_age_year_geom_idx ON schema2rename.sounding_age_year USING gist (geom);



