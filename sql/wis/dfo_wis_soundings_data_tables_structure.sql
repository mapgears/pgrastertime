--
-- PostgreSQL database dump
--

-- Dumped from database version 10.12 (Ubuntu 10.12-0ubuntu0.18.04.1)
-- Dumped by pg_dump version 10.12 (Ubuntu 10.12-0ubuntu0.18.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_with_oids = false;

-- create trigger first

CREATE FUNCTION wis.partition_insert_triggerv2()
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
			INSERT INTO wis.soundings_atlantic_25cm VALUES (NEW.*);
		ELSIF ( NEW.resolution = 0.5 ) THEN
			INSERT INTO wis.soundings_atlantic_50cm VALUES (NEW.*);
		ELSIF ( NEW.resolution = 1 ) THEN
			INSERT INTO wis.soundings_atlantic_1m VALUES (NEW.*);
		ELSIF ( NEW.resolution = 2 ) THEN
			INSERT INTO wis.soundings_atlantic_2m VALUES (NEW.*);
		ELSIF ( NEW.resolution = 4 ) THEN
			INSERT INTO wis.soundings_atlantic_4m VALUES (NEW.*);
		ELSIF ( NEW.resolution = 8 ) THEN
			INSERT INTO wis.soundings_atlantic_8m VALUES (NEW.*);
		ELSIF ( NEW.resolution = 16 ) THEN
			INSERT INTO wis.soundings_atlantic_16m VALUES (NEW.*);
		END IF;

	ELSEIF t_region ='CA' THEN
		IF ( NEW.resolution = 0.25 ) THEN
			INSERT INTO wis.soundings_vnsl_25cm VALUES (NEW.*);
		ELSIF ( NEW.resolution = 0.5 ) THEN
			INSERT INTO wis.soundings_vnsl_50cm VALUES (NEW.*);
		ELSIF ( NEW.resolution = 1 ) THEN
			INSERT INTO wis.soundings_vnsl_1m VALUES (NEW.*);
		ELSIF ( NEW.resolution = 2 ) THEN
			INSERT INTO wis.soundings_vnsl_2m VALUES (NEW.*);
		ELSIF ( NEW.resolution = 4 ) THEN
			INSERT INTO wis.soundings_vnsl_4m VALUES (NEW.*);
		ELSIF ( NEW.resolution = 8 ) THEN
			INSERT INTO wis.soundings_vnsl_8m VALUES (NEW.*);
		ELSIF ( NEW.resolution = 16 ) THEN
			INSERT INTO wis.soundings_vnsl_16m VALUES (NEW.*);
		END IF;

	ELSEIF  t_region = 'Western' THEN
		IF ( NEW.resolution = 0.25 ) THEN
			INSERT INTO wis.soundings_western_25cm VALUES (NEW.*);
		ELSIF ( NEW.resolution = 0.5 ) THEN
			INSERT INTO wis.soundings_western_50cm VALUES (NEW.*);
		ELSIF ( NEW.resolution = 1 ) THEN
			INSERT INTO wis.soundings_western_1m VALUES (NEW.*);
		ELSIF ( NEW.resolution = 2 ) THEN
			INSERT INTO wis.soundings_western_2m VALUES (NEW.*);
		ELSIF ( NEW.resolution = 4 ) THEN
			INSERT INTO wis.soundings_western_4m VALUES (NEW.*);
		ELSIF ( NEW.resolution = 8 ) THEN
			INSERT INTO wis.soundings_western_8m VALUES (NEW.*);
		ELSIF ( NEW.resolution = 16 ) THEN
			INSERT INTO wis.soundings_western_16m VALUES (NEW.*);
		END IF;
	ELSE
		INSERT INTO wis.soundings_no_region VALUES (NEW.*);
	END IF;

	RETURN NULL;

	exception when others then
		INSERT INTO wis.soundings_error VALUES (NEW.*);
		insert into wis.soundings_error_reason values(new.id, sqlerrm );
		raise notice ' % ', SQLERRM;
		RETURN NULL;
END;
$BODY$;


CREATE TABLE wis.soundings_no_region

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

--
-- Name: soundings_16m; Type: TABLE; Schema: wis. Owner: pgrastertime
--

CREATE TABLE wis.soundings_16m (
    id integer NOT NULL,
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979)
);


ALTER TABLE wis.soundings_16m OWNER TO pgrastertime;

--
-- Name: soundings_16m_id_seq; Type: SEQUENCE; Schema: wis. Owner: pgrastertime
--

CREATE SEQUENCE wis.soundings_16m_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE wis.soundings_16m_id_seq OWNER TO pgrastertime;

--
-- Name: soundings_16m_id_seq; Type: SEQUENCE OWNED BY; Schema: wis. Owner: pgrastertime
--

ALTER SEQUENCE wis.soundings_16m_id_seq OWNED BY wis.soundings_16m.id;


--
-- Name: soundings_1m; Type: TABLE; Schema: wis. Owner: pgrastertime
--

CREATE TABLE wis.soundings_1m (
    id integer NOT NULL,
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979)
);


ALTER TABLE wis.soundings_1m OWNER TO pgrastertime;

--
-- Name: soundings_1m_id_seq; Type: SEQUENCE; Schema: wis. Owner: pgrastertime
--

CREATE SEQUENCE wis.soundings_1m_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE wis.soundings_1m_id_seq OWNER TO pgrastertime;

--
-- Name: soundings_1m_id_seq; Type: SEQUENCE OWNED BY; Schema: wis. Owner: pgrastertime
--

ALTER SEQUENCE wis.soundings_1m_id_seq OWNED BY wis.soundings_1m.id;


--
-- Name: soundings_4m; Type: TABLE; Schema: wis. Owner: pgrastertime
--

CREATE TABLE wis.soundings_4m (
    id integer NOT NULL,
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979)
);


ALTER TABLE wis.soundings_4m OWNER TO pgrastertime;

--
-- Name: soundings_4m_id_seq; Type: SEQUENCE; Schema: wis. Owner: pgrastertime
--

CREATE SEQUENCE wis.soundings_4m_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE wis.soundings_4m_id_seq OWNER TO pgrastertime;

--
-- Name: soundings_4m_id_seq; Type: SEQUENCE OWNED BY; Schema: wis. Owner: pgrastertime
--

ALTER SEQUENCE wis.soundings_4m_id_seq OWNED BY wis.soundings_4m.id;


--
-- Name: soundings_8m; Type: TABLE; Schema: wis. Owner: pgrastertime
--

CREATE TABLE wis.soundings_8m (
    id integer NOT NULL,
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979)
);


ALTER TABLE wis.soundings_8m OWNER TO pgrastertime;

--
-- Name: soundings_8m_id_seq; Type: SEQUENCE; Schema: wis. Owner: pgrastertime
--

CREATE SEQUENCE wis.soundings_8m_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE wis.soundings_8m_id_seq OWNER TO pgrastertime;

--
-- Name: soundings_8m_id_seq; Type: SEQUENCE OWNED BY; Schema: wis. Owner: pgrastertime
--

ALTER SEQUENCE wis.soundings_8m_id_seq OWNED BY wis.soundings_8m.id;


--
-- Name: soundings_atlantic_16m; Type: TABLE; Schema: wis. Owner: pgrastertime
--

CREATE TABLE wis.soundings_atlantic_16m (
    id integer DEFAULT nextval('wis.soundings_16m_id_seq'::regclass),
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979)
)
INHERITS (wis.soundings_16m);


ALTER TABLE wis.soundings_atlantic_16m OWNER TO pgrastertime;

--
-- Name: soundings_atlantic_1m; Type: TABLE; Schema: wis. Owner: pgrastertime
--

CREATE TABLE wis.soundings_atlantic_1m (
    id integer DEFAULT nextval('wis.soundings_1m_id_seq'::regclass),
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979)
)
INHERITS (wis.soundings_1m);


ALTER TABLE wis.soundings_atlantic_1m OWNER TO pgrastertime;

--
-- Name: soundings_atlantic_4m; Type: TABLE; Schema: wis. Owner: pgrastertime
--

CREATE TABLE wis.soundings_atlantic_4m (
    id integer DEFAULT nextval('wis.soundings_4m_id_seq'::regclass),
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979)
)
INHERITS (wis.soundings_4m);


ALTER TABLE wis.soundings_atlantic_4m OWNER TO pgrastertime;

--
-- Name: soundings_atlantic_8m; Type: TABLE; Schema: wis. Owner: pgrastertime
--

CREATE TABLE wis.soundings_atlantic_8m (
    id integer DEFAULT nextval('wis.soundings_8m_id_seq'::regclass),
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979)
)
INHERITS (wis.soundings_8m);


ALTER TABLE wis.soundings_atlantic_8m OWNER TO pgrastertime;

--
-- Name: soundings_vnsl_16m; Type: TABLE; Schema: wis. Owner: pgrastertime
--

CREATE TABLE wis.soundings_vnsl_16m (
    id integer DEFAULT nextval('wis.soundings_16m_id_seq'::regclass),
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979)
)
INHERITS (wis.soundings_16m);


ALTER TABLE wis.soundings_vnsl_16m OWNER TO pgrastertime;

--
-- Name: soundings_vnsl_1m; Type: TABLE; Schema: wis. Owner: pgrastertime
--

CREATE TABLE wis.soundings_vnsl_1m (
    id integer DEFAULT nextval('wis.soundings_1m_id_seq'::regclass),
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979)
)
INHERITS (wis.soundings_1m);


ALTER TABLE wis.soundings_vnsl_1m OWNER TO pgrastertime;

--
-- Name: soundings_vnsl_4m; Type: TABLE; Schema: wis. Owner: pgrastertime
--

CREATE TABLE wis.soundings_vnsl_4m (
    id integer DEFAULT nextval('wis.soundings_4m_id_seq'::regclass),
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979)
)
INHERITS (wis.soundings_4m);
ALTER TABLE ONLY wis.soundings_vnsl_4m ALTER COLUMN rast SET STORAGE EXTERNAL;


ALTER TABLE wis.soundings_vnsl_4m OWNER TO pgrastertime;

--
-- Name: soundings_vnsl_8m; Type: TABLE; Schema: wis. Owner: pgrastertime
--

CREATE TABLE wis.soundings_vnsl_8m (
    id integer DEFAULT nextval('wis.soundings_8m_id_seq'::regclass),
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979)
)
INHERITS (wis.soundings_8m);


ALTER TABLE wis.soundings_vnsl_8m OWNER TO pgrastertime;

--
-- Name: soundings_western_16m; Type: TABLE; Schema: wis. Owner: pgrastertime
--

CREATE TABLE wis.soundings_western_16m (
    id integer DEFAULT nextval('wis.soundings_16m_id_seq'::regclass),
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979)
)
INHERITS (wis.soundings_16m);


ALTER TABLE wis.soundings_western_16m OWNER TO pgrastertime;

--
-- Name: soundings_western_4m; Type: TABLE; Schema: wis. Owner: pgrastertime
--

CREATE TABLE wis.soundings_western_4m (
    id integer DEFAULT nextval('wis.soundings_4m_id_seq'::regclass),
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979)
)
INHERITS (wis.soundings_4m);


ALTER TABLE wis.soundings_western_4m OWNER TO pgrastertime;

--
-- Name: soundings_western_8m; Type: TABLE; Schema: wis. Owner: pgrastertime
--

CREATE TABLE wis.soundings_western_8m (
    id integer DEFAULT nextval('wis.soundings_8m_id_seq'::regclass),
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979)
)
INHERITS (wis.soundings_8m);


ALTER TABLE wis.soundings_western_8m OWNER TO pgrastertime;

--
-- Name: soundings_16m id; Type: DEFAULT; Schema: wis. Owner: pgrastertime
--

ALTER TABLE ONLY wis.soundings_16m ALTER COLUMN id SET DEFAULT nextval('wis.soundings_16m_id_seq'::regclass);


--
-- Name: soundings_1m id; Type: DEFAULT; Schema: wis. Owner: pgrastertime
--

ALTER TABLE ONLY wis.soundings_1m ALTER COLUMN id SET DEFAULT nextval('wis.soundings_1m_id_seq'::regclass);


--
-- Name: soundings_4m id; Type: DEFAULT; Schema: wis. Owner: pgrastertime
--

ALTER TABLE ONLY wis.soundings_4m ALTER COLUMN id SET DEFAULT nextval('wis.soundings_4m_id_seq'::regclass);


--
-- Name: soundings_8m id; Type: DEFAULT; Schema: wis. Owner: pgrastertime
--

ALTER TABLE ONLY wis.soundings_8m ALTER COLUMN id SET DEFAULT nextval('wis.soundings_8m_id_seq'::regclass);


--
-- Name: soundings_16m soundings_16m_pk; Type: CONSTRAINT; Schema: wis. Owner: pgrastertime
--

ALTER TABLE ONLY wis.soundings_16m
    ADD CONSTRAINT soundings_16m_pk PRIMARY KEY (id);


--
-- Name: soundings_1m soundings_1m_pk; Type: CONSTRAINT; Schema: wis. Owner: pgrastertime
--

ALTER TABLE ONLY wis.soundings_1m
    ADD CONSTRAINT soundings_1m_pk PRIMARY KEY (id);


--
-- Name: soundings_4m soundings_4m_pk; Type: CONSTRAINT; Schema: wis. Owner: pgrastertime
--

ALTER TABLE ONLY wis.soundings_4m
    ADD CONSTRAINT soundings_4m_pk PRIMARY KEY (id);


--
-- Name: soundings_8m soundings_8m_pk; Type: CONSTRAINT; Schema: wis. Owner: pgrastertime
--

ALTER TABLE ONLY wis.soundings_8m
    ADD CONSTRAINT soundings_8m_pk PRIMARY KEY (id);


--
-- Name: soundings_atlantic_16m soundings_atlantic_16m_pkey; Type: CONSTRAINT; Schema: wis. Owner: pgrastertime
--

ALTER TABLE ONLY wis.soundings_atlantic_16m
    ADD CONSTRAINT soundings_atlantic_16m_pkey PRIMARY KEY (id);


--
-- Name: soundings_atlantic_1m soundings_atlantic_1m_pkey; Type: CONSTRAINT; Schema: wis. Owner: pgrastertime
--

ALTER TABLE ONLY wis.soundings_atlantic_1m
    ADD CONSTRAINT soundings_atlantic_1m_pkey PRIMARY KEY (id);


--
-- Name: soundings_atlantic_4m soundings_atlantic_4m_pkey; Type: CONSTRAINT; Schema: wis. Owner: pgrastertime
--

ALTER TABLE ONLY wis.soundings_atlantic_4m
    ADD CONSTRAINT soundings_atlantic_4m_pkey PRIMARY KEY (id);


--
-- Name: soundings_atlantic_8m soundings_atlantic_8m_pkey; Type: CONSTRAINT; Schema: wis. Owner: pgrastertime
--

ALTER TABLE ONLY wis.soundings_atlantic_8m
    ADD CONSTRAINT soundings_atlantic_8m_pkey PRIMARY KEY (id);


--
-- Name: soundings_vnsl_16m soundings_vnsl_16m_pkey; Type: CONSTRAINT; Schema: wis. Owner: pgrastertime
--

ALTER TABLE ONLY wis.soundings_vnsl_16m
    ADD CONSTRAINT soundings_vnsl_16m_pkey PRIMARY KEY (id);


--
-- Name: soundings_vnsl_1m soundings_vnsl_1m_pkey; Type: CONSTRAINT; Schema: wis. Owner: pgrastertime
--

ALTER TABLE ONLY wis.soundings_vnsl_1m
    ADD CONSTRAINT soundings_vnsl_1m_pkey PRIMARY KEY (id);


--
-- Name: soundings_vnsl_4m soundings_vnsl_4m_pkey; Type: CONSTRAINT; Schema: wis. Owner: pgrastertime
--

ALTER TABLE ONLY wis.soundings_vnsl_4m
    ADD CONSTRAINT soundings_vnsl_4m_pkey PRIMARY KEY (id);


--
-- Name: soundings_vnsl_8m soundings_vnsl_8m_pkey; Type: CONSTRAINT; Schema: wis. Owner: pgrastertime
--

ALTER TABLE ONLY wis.soundings_vnsl_8m
    ADD CONSTRAINT soundings_vnsl_8m_pkey PRIMARY KEY (id);


--
-- Name: soundings_western_16m soundings_western_16m_pkey; Type: CONSTRAINT; Schema: wis. Owner: pgrastertime
--

ALTER TABLE ONLY wis.soundings_western_16m
    ADD CONSTRAINT soundings_western_16m_pkey PRIMARY KEY (id);


--
-- Name: soundings_western_4m soundings_western_4m_pkey; Type: CONSTRAINT; Schema: wis. Owner: pgrastertime
--

ALTER TABLE ONLY wis.soundings_western_4m
    ADD CONSTRAINT soundings_western_4m_pkey PRIMARY KEY (id);


--
-- Name: soundings_western_8m soundings_western_8m_pkey; Type: CONSTRAINT; Schema: wis. Owner: pgrastertime
--

ALTER TABLE ONLY wis.soundings_western_8m
    ADD CONSTRAINT soundings_western_8m_pkey PRIMARY KEY (id);


--
-- Name: soundings_16m_lower_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_16m_lower_sysperiod ON wis.soundings_16m USING btree (lower(sys_period));


--
-- Name: soundings_16m_metadata_id; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_16m_metadata_id ON wis.soundings_16m USING btree (metadata_id);


--
-- Name: soundings_16m_raster; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_16m_raster ON wis.soundings_16m USING gist (public.st_convexhull(rast));


--
-- Name: soundings_16m_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_16m_sysperiod ON wis.soundings_16m USING gist (sys_period);


--
-- Name: soundings_16m_tile_extent_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_16m_tile_extent_idx ON wis.soundings_16m USING gist (tile_extent);


--
-- Name: soundings_16m_tile_geom_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_16m_tile_geom_idx ON wis.soundings_16m USING gist (tile_geom);


--
-- Name: soundings_1m_lower_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_1m_lower_sysperiod ON wis.soundings_1m USING btree (lower(sys_period));


--
-- Name: soundings_1m_metadata_id; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_1m_metadata_id ON wis.soundings_1m USING btree (metadata_id);


--
-- Name: soundings_1m_raster; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_1m_raster ON wis.soundings_1m USING gist (public.st_convexhull(rast));


--
-- Name: soundings_1m_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_1m_sysperiod ON wis.soundings_1m USING gist (sys_period);


--
-- Name: soundings_1m_tile_extent_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_1m_tile_extent_idx ON wis.soundings_1m USING gist (tile_extent);


--
-- Name: soundings_1m_tile_geom_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_1m_tile_geom_idx ON wis.soundings_1m USING gist (tile_geom);


--
-- Name: soundings_4m_lower_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_4m_lower_sysperiod ON wis.soundings_4m USING btree (lower(sys_period));


--
-- Name: soundings_4m_metadata_id; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_4m_metadata_id ON wis.soundings_4m USING btree (metadata_id);


--
-- Name: soundings_4m_raster; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_4m_raster ON wis.soundings_4m USING gist (public.st_convexhull(rast));


--
-- Name: soundings_4m_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_4m_sysperiod ON wis.soundings_4m USING gist (sys_period);


--
-- Name: soundings_4m_tile_extent_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_4m_tile_extent_idx ON wis.soundings_4m USING gist (tile_extent);


--
-- Name: soundings_4m_tile_geom_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_4m_tile_geom_idx ON wis.soundings_4m USING gist (tile_geom);


--
-- Name: soundings_8m_lower_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_8m_lower_sysperiod ON wis.soundings_8m USING btree (lower(sys_period));


--
-- Name: soundings_8m_metadata_id; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_8m_metadata_id ON wis.soundings_8m USING btree (metadata_id);


--
-- Name: soundings_8m_raster; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_8m_raster ON wis.soundings_8m USING gist (public.st_convexhull(rast));


--
-- Name: soundings_8m_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_8m_sysperiod ON wis.soundings_8m USING gist (sys_period);


--
-- Name: soundings_8m_tile_extent_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_8m_tile_extent_idx ON wis.soundings_8m USING gist (tile_extent);


--
-- Name: soundings_8m_tile_geom_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_8m_tile_geom_idx ON wis.soundings_8m USING gist (tile_geom);


--
-- Name: soundings_atlantic_16m_lower_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_16m_lower_sysperiod ON wis.soundings_atlantic_16m USING btree (lower(sys_period));


--
-- Name: soundings_atlantic_16m_metadata_id; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_16m_metadata_id ON wis.soundings_atlantic_16m USING btree (metadata_id);


--
-- Name: soundings_atlantic_16m_raster; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_16m_raster ON wis.soundings_atlantic_16m USING gist (public.st_convexhull(rast));


--
-- Name: soundings_atlantic_16m_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_16m_sysperiod ON wis.soundings_atlantic_16m USING gist (sys_period);


--
-- Name: soundings_atlantic_16m_tile_extent_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_16m_tile_extent_idx ON wis.soundings_atlantic_16m USING gist (tile_extent);


--
-- Name: soundings_atlantic_16m_tile_geom_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_16m_tile_geom_idx ON wis.soundings_atlantic_16m USING gist (tile_geom);


--
-- Name: soundings_atlantic_1m_lower_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_1m_lower_sysperiod ON wis.soundings_atlantic_1m USING btree (lower(sys_period));


--
-- Name: soundings_atlantic_1m_metadata_id; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_1m_metadata_id ON wis.soundings_atlantic_1m USING btree (metadata_id);


--
-- Name: soundings_atlantic_1m_raster; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_1m_raster ON wis.soundings_atlantic_1m USING gist (public.st_convexhull(rast));


--
-- Name: soundings_atlantic_1m_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_1m_sysperiod ON wis.soundings_atlantic_1m USING gist (sys_period);


--
-- Name: soundings_atlantic_1m_tile_extent_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_1m_tile_extent_idx ON wis.soundings_atlantic_1m USING gist (tile_extent);


--
-- Name: soundings_atlantic_1m_tile_geom_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_1m_tile_geom_idx ON wis.soundings_atlantic_1m USING gist (tile_geom);


--
-- Name: soundings_atlantic_4m_lower_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_4m_lower_sysperiod ON wis.soundings_atlantic_4m USING btree (lower(sys_period));


--
-- Name: soundings_atlantic_4m_metadata_id; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_4m_metadata_id ON wis.soundings_atlantic_4m USING btree (metadata_id);


--
-- Name: soundings_atlantic_4m_raster; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_4m_raster ON wis.soundings_atlantic_4m USING gist (public.st_convexhull(rast));


--
-- Name: soundings_atlantic_4m_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_4m_sysperiod ON wis.soundings_atlantic_4m USING gist (sys_period);


--
-- Name: soundings_atlantic_4m_tile_extent_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_4m_tile_extent_idx ON wis.soundings_atlantic_4m USING gist (tile_extent);


--
-- Name: soundings_atlantic_4m_tile_geom_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_4m_tile_geom_idx ON wis.soundings_atlantic_4m USING gist (tile_geom);


--
-- Name: soundings_atlantic_8m_lower_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_8m_lower_sysperiod ON wis.soundings_atlantic_8m USING btree (lower(sys_period));


--
-- Name: soundings_atlantic_8m_metadata_id; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_8m_metadata_id ON wis.soundings_atlantic_8m USING btree (metadata_id);


--
-- Name: soundings_atlantic_8m_raster; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_8m_raster ON wis.soundings_atlantic_8m USING gist (public.st_convexhull(rast));


--
-- Name: soundings_atlantic_8m_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_8m_sysperiod ON wis.soundings_atlantic_8m USING gist (sys_period);


--
-- Name: soundings_atlantic_8m_tile_extent_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_8m_tile_extent_idx ON wis.soundings_atlantic_8m USING gist (tile_extent);


--
-- Name: soundings_atlantic_8m_tile_geom_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_8m_tile_geom_idx ON wis.soundings_atlantic_8m USING gist (tile_geom);


--
-- Name: soundings_vnsl_16m_lower_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_16m_lower_sysperiod ON wis.soundings_vnsl_16m USING btree (lower(sys_period));


--
-- Name: soundings_vnsl_16m_metadata_id; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_16m_metadata_id ON wis.soundings_vnsl_16m USING btree (metadata_id);


--
-- Name: soundings_vnsl_16m_raster; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_16m_raster ON wis.soundings_vnsl_16m USING gist (public.st_convexhull(rast));


--
-- Name: soundings_vnsl_16m_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_16m_sysperiod ON wis.soundings_vnsl_16m USING gist (sys_period);


--
-- Name: soundings_vnsl_16m_tile_extent_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_16m_tile_extent_idx ON wis.soundings_vnsl_16m USING gist (tile_extent);


--
-- Name: soundings_vnsl_16m_tile_geom_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_16m_tile_geom_idx ON wis.soundings_vnsl_16m USING gist (tile_geom);


--
-- Name: soundings_vnsl_1m_lower_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_1m_lower_sysperiod ON wis.soundings_vnsl_1m USING btree (lower(sys_period));


--
-- Name: soundings_vnsl_1m_metadata_id; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_1m_metadata_id ON wis.soundings_vnsl_1m USING btree (metadata_id);


--
-- Name: soundings_vnsl_1m_raster; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_1m_raster ON wis.soundings_vnsl_1m USING gist (public.st_convexhull(rast));


--
-- Name: soundings_vnsl_1m_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_1m_sysperiod ON wis.soundings_vnsl_1m USING gist (sys_period);


--
-- Name: soundings_vnsl_1m_tile_extent_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_1m_tile_extent_idx ON wis.soundings_vnsl_1m USING gist (tile_extent);


--
-- Name: soundings_vnsl_1m_tile_geom_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_1m_tile_geom_idx ON wis.soundings_vnsl_1m USING gist (tile_geom);


--
-- Name: soundings_vnsl_4m_lower_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_4m_lower_sysperiod ON wis.soundings_vnsl_4m USING btree (lower(sys_period));


--
-- Name: soundings_vnsl_4m_metadata_id; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_4m_metadata_id ON wis.soundings_vnsl_4m USING btree (metadata_id);


--
-- Name: soundings_vnsl_4m_raster; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_4m_raster ON wis.soundings_vnsl_4m USING gist (public.st_convexhull(rast));


--
-- Name: soundings_vnsl_4m_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_4m_sysperiod ON wis.soundings_vnsl_4m USING gist (sys_period);


--
-- Name: soundings_vnsl_4m_tile_extent_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_4m_tile_extent_idx ON wis.soundings_vnsl_4m USING gist (tile_extent);


--
-- Name: soundings_vnsl_4m_tile_geom_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_4m_tile_geom_idx ON wis.soundings_vnsl_4m USING gist (tile_geom);


--
-- Name: soundings_vnsl_8m_lower_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_8m_lower_sysperiod ON wis.soundings_vnsl_8m USING btree (lower(sys_period));


--
-- Name: soundings_vnsl_8m_metadata_id; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_8m_metadata_id ON wis.soundings_vnsl_8m USING btree (metadata_id);


--
-- Name: soundings_vnsl_8m_raster; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_8m_raster ON wis.soundings_vnsl_8m USING gist (public.st_convexhull(rast));


--
-- Name: soundings_vnsl_8m_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_8m_sysperiod ON wis.soundings_vnsl_8m USING gist (sys_period);


--
-- Name: soundings_vnsl_8m_tile_extent_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_8m_tile_extent_idx ON wis.soundings_vnsl_8m USING gist (tile_extent);


--
-- Name: soundings_vnsl_8m_tile_geom_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_8m_tile_geom_idx ON wis.soundings_vnsl_8m USING gist (tile_geom);


--
-- Name: soundings_western_16m_lower_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_western_16m_lower_sysperiod ON wis.soundings_western_16m USING btree (lower(sys_period));


--
-- Name: soundings_western_16m_metadata_id; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_western_16m_metadata_id ON wis.soundings_western_16m USING btree (metadata_id);


--
-- Name: soundings_western_16m_raster; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_western_16m_raster ON wis.soundings_western_16m USING gist (public.st_convexhull(rast));


--
-- Name: soundings_western_16m_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_western_16m_sysperiod ON wis.soundings_western_16m USING gist (sys_period);


--
-- Name: soundings_western_16m_tile_extent_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_western_16m_tile_extent_idx ON wis.soundings_western_16m USING gist (tile_extent);


--
-- Name: soundings_western_16m_tile_geom_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_western_16m_tile_geom_idx ON wis.soundings_western_16m USING gist (tile_geom);


--
-- Name: soundings_western_4m_lower_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_western_4m_lower_sysperiod ON wis.soundings_western_4m USING btree (lower(sys_period));


--
-- Name: soundings_western_4m_metadata_id; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_western_4m_metadata_id ON wis.soundings_western_4m USING btree (metadata_id);


--
-- Name: soundings_western_4m_raster; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_western_4m_raster ON wis.soundings_western_4m USING gist (public.st_convexhull(rast));


--
-- Name: soundings_western_4m_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_western_4m_sysperiod ON wis.soundings_western_4m USING gist (sys_period);


--
-- Name: soundings_western_4m_tile_extent_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_western_4m_tile_extent_idx ON wis.soundings_western_4m USING gist (tile_extent);


--
-- Name: soundings_western_4m_tile_geom_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_western_4m_tile_geom_idx ON wis.soundings_western_4m USING gist (tile_geom);


--
-- Name: soundings_western_8m_lower_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_western_8m_lower_sysperiod ON wis.soundings_western_8m USING btree (lower(sys_period));


--
-- Name: soundings_western_8m_metadata_id; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_western_8m_metadata_id ON wis.soundings_western_8m USING btree (metadata_id);


--
-- Name: soundings_western_8m_raster; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_western_8m_raster ON wis.soundings_western_8m USING gist (public.st_convexhull(rast));


--
-- Name: soundings_western_8m_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_western_8m_sysperiod ON wis.soundings_western_8m USING gist (sys_period);


--
-- Name: soundings_western_8m_tile_extent_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_western_8m_tile_extent_idx ON wis.soundings_western_8m USING gist (tile_extent);


--
-- Name: soundings_western_8m_tile_geom_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_western_8m_tile_geom_idx ON wis.soundings_western_8m USING gist (tile_geom);

--
-- Name: sounding_age; Type: TABLE; Schema: wis. Owner: pgrastertime
--

CREATE TABLE wis.sounding_age (
    year double precision,
    geom public.geometry(Polygon,3979)
);


ALTER TABLE wis.sounding_age OWNER TO pgrastertime;

--
-- Name: sounding_age_year; Type: TABLE; Schema: wis. Owner: pgrastertime
--

CREATE TABLE wis.sounding_age_year (
    geom public.geometry(MultiPolygon,3979),
    year double precision
);


ALTER TABLE wis.sounding_age_year OWNER TO pgrastertime;

--
-- Name: soundings; Type: TABLE; Schema: wis. Owner: pgrastertime
--

CREATE TABLE wis.soundings (
    id integer NOT NULL,
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979)
);


ALTER TABLE wis.soundings OWNER TO pgrastertime;

-- add trigger to this table

CREATE TRIGGER partition_insert
    BEFORE INSERT
    ON wis.soundings
    FOR EACH ROW
    EXECUTE PROCEDURE wis.partition_insert_triggerv2();


--
-- Name: soundings_25cm; Type: TABLE; Schema: wis. Owner: pgrastertime
--

CREATE TABLE wis.soundings_25cm (
    id integer NOT NULL,
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979)
);


ALTER TABLE wis.soundings_25cm OWNER TO pgrastertime;

--
-- Name: soundings_25cm_id_seq; Type: SEQUENCE; Schema: wis. Owner: pgrastertime
--

CREATE SEQUENCE wis.soundings_25cm_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE wis.soundings_25cm_id_seq OWNER TO pgrastertime;

--
-- Name: soundings_25cm_id_seq; Type: SEQUENCE OWNED BY; Schema: wis. Owner: pgrastertime
--

ALTER SEQUENCE wis.soundings_25cm_id_seq OWNED BY wis.soundings_25cm.id;


--
-- Name: soundings_50cm; Type: TABLE; Schema: wis. Owner: pgrastertime
--

CREATE TABLE wis.soundings_50cm (
    id integer NOT NULL,
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979)
);


ALTER TABLE wis.soundings_50cm OWNER TO pgrastertime;

--
-- Name: soundings_50cm_id_seq; Type: SEQUENCE; Schema: wis. Owner: pgrastertime
--

CREATE SEQUENCE wis.soundings_50cm_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE wis.soundings_50cm_id_seq OWNER TO pgrastertime;

--
-- Name: soundings_50cm_id_seq; Type: SEQUENCE OWNED BY; Schema: wis. Owner: pgrastertime
--

ALTER SEQUENCE wis.soundings_50cm_id_seq OWNED BY wis.soundings_50cm.id;


--
-- Name: soundings_atlantic_25cm; Type: TABLE; Schema: wis. Owner: pgrastertime
--

CREATE TABLE wis.soundings_atlantic_25cm (
    id integer DEFAULT nextval('wis.soundings_25cm_id_seq'::regclass),
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979)
)
INHERITS (wis.soundings_25cm);


ALTER TABLE wis.soundings_atlantic_25cm OWNER TO pgrastertime;

--
-- Name: soundings_atlantic_50cm; Type: TABLE; Schema: wis. Owner: pgrastertime
--

CREATE TABLE wis.soundings_atlantic_50cm (
    id integer DEFAULT nextval('wis.soundings_50cm_id_seq'::regclass),
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979)
)
INHERITS (wis.soundings_50cm);


ALTER TABLE wis.soundings_atlantic_50cm OWNER TO pgrastertime;

--
-- Name: soundings_error; Type: TABLE; Schema: wis. Owner: stecyr
--

CREATE TABLE wis.soundings_error (
    id integer NOT NULL,
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979)
);


ALTER TABLE wis.soundings_error OWNER TO stecyr;

--
-- Name: soundings_id_seq; Type: SEQUENCE; Schema: wis. Owner: pgrastertime
--

CREATE SEQUENCE wis.soundings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE wis.soundings_id_seq OWNER TO pgrastertime;

--
-- Name: soundings_id_seq; Type: SEQUENCE OWNED BY; Schema: wis. Owner: pgrastertime
--

ALTER SEQUENCE wis.soundings_id_seq OWNED BY wis.soundings.id;


--
-- Name: soundings_vnsl_25cm; Type: TABLE; Schema: wis. Owner: pgrastertime
--

CREATE TABLE wis.soundings_vnsl_25cm (
    id integer DEFAULT nextval('wis.soundings_25cm_id_seq'::regclass),
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979)
)
INHERITS (wis.soundings_25cm);


ALTER TABLE wis.soundings_vnsl_25cm OWNER TO pgrastertime;

--
-- Name: soundings_vnsl_50cm; Type: TABLE; Schema: wis. Owner: pgrastertime
--

CREATE TABLE wis.soundings_vnsl_50cm (
    id integer DEFAULT nextval('wis.soundings_50cm_id_seq'::regclass),
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979)
)
INHERITS (wis.soundings_50cm);


ALTER TABLE wis.soundings_vnsl_50cm OWNER TO pgrastertime;

--
-- Name: soundings_western_1m; Type: TABLE; Schema: wis. Owner: pgrastertime
--

CREATE TABLE wis.soundings_western_1m (
    id integer DEFAULT nextval('wis.soundings_1m_id_seq'::regclass),
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979)
)
INHERITS (wis.soundings_1m);


ALTER TABLE wis.soundings_western_1m OWNER TO pgrastertime;

--
-- Name: soundings_western_25cm; Type: TABLE; Schema: wis. Owner: pgrastertime
--

CREATE TABLE wis.soundings_western_25cm (
    id integer DEFAULT nextval('wis.soundings_25cm_id_seq'::regclass),
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979)
)
INHERITS (wis.soundings_25cm);


ALTER TABLE wis.soundings_western_25cm OWNER TO pgrastertime;

--
-- Name: soundings_western_50cm; Type: TABLE; Schema: wis. Owner: pgrastertime
--

CREATE TABLE wis.soundings_western_50cm (
    id integer DEFAULT nextval('wis.soundings_50cm_id_seq'::regclass),
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979)
)
INHERITS (wis.soundings_50cm);


ALTER TABLE wis.soundings_western_50cm OWNER TO pgrastertime;

--
-- Name: soundings id; Type: DEFAULT; Schema: wis. Owner: pgrastertime
--

ALTER TABLE ONLY wis.soundings ALTER COLUMN id SET DEFAULT nextval('wis.soundings_id_seq'::regclass);


--
-- Name: soundings_25cm id; Type: DEFAULT; Schema: wis. Owner: pgrastertime
--

ALTER TABLE ONLY wis.soundings_25cm ALTER COLUMN id SET DEFAULT nextval('wis.soundings_25cm_id_seq'::regclass);


--
-- Name: soundings_50cm id; Type: DEFAULT; Schema: wis. Owner: pgrastertime
--

ALTER TABLE ONLY wis.soundings_50cm ALTER COLUMN id SET DEFAULT nextval('wis.soundings_50cm_id_seq'::regclass);


--
-- Name: soundings_25cm soundings_25cm_pk; Type: CONSTRAINT; Schema: wis. Owner: pgrastertime
--

ALTER TABLE ONLY wis.soundings_25cm
    ADD CONSTRAINT soundings_25cm_pk PRIMARY KEY (id);


--
-- Name: soundings_50cm soundings_50cm_pk; Type: CONSTRAINT; Schema: wis. Owner: pgrastertime
--

ALTER TABLE ONLY wis.soundings_50cm
    ADD CONSTRAINT soundings_50cm_pk PRIMARY KEY (id);


--
-- Name: soundings_atlantic_25cm soundings_atlantic_25cm_pkey; Type: CONSTRAINT; Schema: wis. Owner: pgrastertime
--

ALTER TABLE ONLY wis.soundings_atlantic_25cm
    ADD CONSTRAINT soundings_atlantic_25cm_pkey PRIMARY KEY (id);


--
-- Name: soundings_atlantic_50cm soundings_atlantic_50cm_pkey; Type: CONSTRAINT; Schema: wis. Owner: pgrastertime
--

ALTER TABLE ONLY wis.soundings_atlantic_50cm
    ADD CONSTRAINT soundings_atlantic_50cm_pkey PRIMARY KEY (id);


--
-- Name: soundings_error soundings_error_pk; Type: CONSTRAINT; Schema: wis. Owner: stecyr
--

ALTER TABLE ONLY wis.soundings_error
    ADD CONSTRAINT soundings_error_pk PRIMARY KEY (id);


--
-- Name: soundings_vnsl_25cm soundings_vnsl_25cm_pkey; Type: CONSTRAINT; Schema: wis. Owner: pgrastertime
--

ALTER TABLE ONLY wis.soundings_vnsl_25cm
    ADD CONSTRAINT soundings_vnsl_25cm_pkey PRIMARY KEY (id);


--
-- Name: soundings_vnsl_50cm soundings_vnsl_50cm_pkey; Type: CONSTRAINT; Schema: wis. Owner: pgrastertime
--

ALTER TABLE ONLY wis.soundings_vnsl_50cm
    ADD CONSTRAINT soundings_vnsl_50cm_pkey PRIMARY KEY (id);


--
-- Name: soundings_western_1m soundings_western_1m_pkey; Type: CONSTRAINT; Schema: wis. Owner: pgrastertime
--

ALTER TABLE ONLY wis.soundings_western_1m
    ADD CONSTRAINT soundings_western_1m_pkey PRIMARY KEY (id);


--
-- Name: soundings_western_25cm soundings_western_25cm_pkey; Type: CONSTRAINT; Schema: wis. Owner: pgrastertime
--

ALTER TABLE ONLY wis.soundings_western_25cm
    ADD CONSTRAINT soundings_western_25cm_pkey PRIMARY KEY (id);


--
-- Name: soundings_western_50cm soundings_western_50cm_pkey; Type: CONSTRAINT; Schema: wis. Owner: pgrastertime
--

ALTER TABLE ONLY wis.soundings_western_50cm
    ADD CONSTRAINT soundings_western_50cm_pkey PRIMARY KEY (id);


--
-- Name: sounding_age_geom_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX sounding_age_geom_idx ON wis.sounding_age USING gist (geom);


--
-- Name: sounding_age_year_geom_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX sounding_age_year_geom_idx ON wis.sounding_age_year USING gist (geom);


--
-- Name: soundings_25cm_lower_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_25cm_lower_sysperiod ON wis.soundings_25cm USING btree (lower(sys_period));


--
-- Name: soundings_25cm_metadata_id; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_25cm_metadata_id ON wis.soundings_25cm USING btree (metadata_id);


--
-- Name: soundings_25cm_raster; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_25cm_raster ON wis.soundings_25cm USING gist (public.st_convexhull(rast));


--
-- Name: soundings_25cm_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_25cm_sysperiod ON wis.soundings_25cm USING gist (sys_period);


--
-- Name: soundings_25cm_tile_extent_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_25cm_tile_extent_idx ON wis.soundings_25cm USING gist (tile_extent);


--
-- Name: soundings_25cm_tile_geom_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_25cm_tile_geom_idx ON wis.soundings_25cm USING gist (tile_geom);


--
-- Name: soundings_50cm_lower_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_50cm_lower_sysperiod ON wis.soundings_50cm USING btree (lower(sys_period));


--
-- Name: soundings_50cm_metadata_id; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_50cm_metadata_id ON wis.soundings_50cm USING btree (metadata_id);


--
-- Name: soundings_50cm_raster; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_50cm_raster ON wis.soundings_50cm USING gist (public.st_convexhull(rast));


--
-- Name: soundings_50cm_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_50cm_sysperiod ON wis.soundings_50cm USING gist (sys_period);


--
-- Name: soundings_50cm_tile_extent_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_50cm_tile_extent_idx ON wis.soundings_50cm USING gist (tile_extent);


--
-- Name: soundings_50cm_tile_geom_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_50cm_tile_geom_idx ON wis.soundings_50cm USING gist (tile_geom);


--
-- Name: soundings_atlantic_25cm_lower_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_25cm_lower_sysperiod ON wis.soundings_atlantic_25cm USING btree (lower(sys_period));


--
-- Name: soundings_atlantic_25cm_metadata_id; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_25cm_metadata_id ON wis.soundings_atlantic_25cm USING btree (metadata_id);


--
-- Name: soundings_atlantic_25cm_raster; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_25cm_raster ON wis.soundings_atlantic_25cm USING gist (public.st_convexhull(rast));


--
-- Name: soundings_atlantic_25cm_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_25cm_sysperiod ON wis.soundings_atlantic_25cm USING gist (sys_period);


--
-- Name: soundings_atlantic_25cm_tile_extent_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_25cm_tile_extent_idx ON wis.soundings_atlantic_25cm USING gist (tile_extent);


--
-- Name: soundings_atlantic_25cm_tile_geom_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_25cm_tile_geom_idx ON wis.soundings_atlantic_25cm USING gist (tile_geom);


--
-- Name: soundings_atlantic_50cm_lower_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_50cm_lower_sysperiod ON wis.soundings_atlantic_50cm USING btree (lower(sys_period));


--
-- Name: soundings_atlantic_50cm_metadata_id; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_50cm_metadata_id ON wis.soundings_atlantic_50cm USING btree (metadata_id);


--
-- Name: soundings_atlantic_50cm_raster; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_50cm_raster ON wis.soundings_atlantic_50cm USING gist (public.st_convexhull(rast));


--
-- Name: soundings_atlantic_50cm_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_50cm_sysperiod ON wis.soundings_atlantic_50cm USING gist (sys_period);


--
-- Name: soundings_atlantic_50cm_tile_extent_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_50cm_tile_extent_idx ON wis.soundings_atlantic_50cm USING gist (tile_extent);


--
-- Name: soundings_atlantic_50cm_tile_geom_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_50cm_tile_geom_idx ON wis.soundings_atlantic_50cm USING gist (tile_geom);


--
-- Name: soundings_vnsl_25cm_lower_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_25cm_lower_sysperiod ON wis.soundings_vnsl_25cm USING btree (lower(sys_period));


--
-- Name: soundings_vnsl_25cm_metadata_id; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_25cm_metadata_id ON wis.soundings_vnsl_25cm USING btree (metadata_id);


--
-- Name: soundings_vnsl_25cm_raster; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_25cm_raster ON wis.soundings_vnsl_25cm USING gist (public.st_convexhull(rast));


--
-- Name: soundings_vnsl_25cm_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_25cm_sysperiod ON wis.soundings_vnsl_25cm USING gist (sys_period);


--
-- Name: soundings_vnsl_25cm_tile_extent_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_25cm_tile_extent_idx ON wis.soundings_vnsl_25cm USING gist (tile_extent);


--
-- Name: soundings_vnsl_25cm_tile_geom_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_25cm_tile_geom_idx ON wis.soundings_vnsl_25cm USING gist (tile_geom);


--
-- Name: soundings_vnsl_50cm_lower_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_50cm_lower_sysperiod ON wis.soundings_vnsl_50cm USING btree (lower(sys_period));


--
-- Name: soundings_vnsl_50cm_metadata_id; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_50cm_metadata_id ON wis.soundings_vnsl_50cm USING btree (metadata_id);


--
-- Name: soundings_vnsl_50cm_raster; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_50cm_raster ON wis.soundings_vnsl_50cm USING gist (public.st_convexhull(rast));


--
-- Name: soundings_vnsl_50cm_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_50cm_sysperiod ON wis.soundings_vnsl_50cm USING gist (sys_period);


--
-- Name: soundings_vnsl_50cm_tile_extent_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_50cm_tile_extent_idx ON wis.soundings_vnsl_50cm USING gist (tile_extent);


--
-- Name: soundings_vnsl_50cm_tile_geom_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_50cm_tile_geom_idx ON wis.soundings_vnsl_50cm USING gist (tile_geom);


--
-- Name: soundings_western_1m_lower_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_western_1m_lower_sysperiod ON wis.soundings_western_1m USING btree (lower(sys_period));


--
-- Name: soundings_western_1m_metadata_id; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_western_1m_metadata_id ON wis.soundings_western_1m USING btree (metadata_id);


--
-- Name: soundings_western_1m_raster; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_western_1m_raster ON wis.soundings_western_1m USING gist (public.st_convexhull(rast));


--
-- Name: soundings_western_1m_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_western_1m_sysperiod ON wis.soundings_western_1m USING gist (sys_period);


--
-- Name: soundings_western_1m_tile_extent_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_western_1m_tile_extent_idx ON wis.soundings_western_1m USING gist (tile_extent);


--
-- Name: soundings_western_1m_tile_geom_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_western_1m_tile_geom_idx ON wis.soundings_western_1m USING gist (tile_geom);


--
-- Name: soundings_western_25cm_lower_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_western_25cm_lower_sysperiod ON wis.soundings_western_25cm USING btree (lower(sys_period));


--
-- Name: soundings_western_25cm_metadata_id; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_western_25cm_metadata_id ON wis.soundings_western_25cm USING btree (metadata_id);


--
-- Name: soundings_western_25cm_raster; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_western_25cm_raster ON wis.soundings_western_25cm USING gist (public.st_convexhull(rast));


--
-- Name: soundings_western_25cm_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_western_25cm_sysperiod ON wis.soundings_western_25cm USING gist (sys_period);


--
-- Name: soundings_western_25cm_tile_extent_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_western_25cm_tile_extent_idx ON wis.soundings_western_25cm USING gist (tile_extent);


--
-- Name: soundings_western_25cm_tile_geom_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_western_25cm_tile_geom_idx ON wis.soundings_western_25cm USING gist (tile_geom);


--
-- Name: soundings_western_50cm_lower_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_western_50cm_lower_sysperiod ON wis.soundings_western_50cm USING btree (lower(sys_period));


--
-- Name: soundings_western_50cm_metadata_id; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_western_50cm_metadata_id ON wis.soundings_western_50cm USING btree (metadata_id);


--
-- Name: soundings_western_50cm_raster; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_western_50cm_raster ON wis.soundings_western_50cm USING gist (public.st_convexhull(rast));


--
-- Name: soundings_western_50cm_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_western_50cm_sysperiod ON wis.soundings_western_50cm USING gist (sys_period);


--
-- Name: soundings_western_50cm_tile_extent_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_western_50cm_tile_extent_idx ON wis.soundings_western_50cm USING gist (tile_extent);


--
-- Name: soundings_western_50cm_tile_geom_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_western_50cm_tile_geom_idx ON wis.soundings_western_50cm USING gist (tile_geom);


--
-- Name: soundings partition_insert; Type: TRIGGER; Schema: wis. Owner: pgrastertime
--

CREATE TRIGGER partition_insert BEFORE INSERT ON wis.soundings FOR EACH ROW EXECUTE PROCEDURE wis.partition_insert_triggerv2();

--
-- Name: soundings_2m; Type: TABLE; Schema: wis. Owner: pgrastertime
--

CREATE TABLE wis.soundings_2m (
    id integer NOT NULL,
    tile_id bigint,
    rast wis.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent wis.geometry(Polygon),
    tile_geom wis.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom wis.geometry(MultiPolygon,3979)
);


ALTER TABLE wis.soundings_2m OWNER TO pgrastertime;

--
-- Name: soundings_2m_id_seq; Type: SEQUENCE; Schema: wis. Owner: pgrastertime
--

CREATE SEQUENCE wis.soundings_2m_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE wis.soundings_2m_id_seq OWNER TO pgrastertime;

--
-- Name: soundings_2m_id_seq; Type: SEQUENCE OWNED BY; Schema: wis. Owner: pgrastertime
--

ALTER SEQUENCE wis.soundings_2m_id_seq OWNED BY wis.soundings_2m.id;


--
-- Name: soundings_atlantic_2m; Type: TABLE; Schema: wis. Owner: pgrastertime
--

CREATE TABLE wis.soundings_atlantic_2m (
    id integer DEFAULT nextval('wis.soundings_2m_id_seq'::regclass),
    tile_id bigint,
    rast wis.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent wis.geometry(Polygon),
    tile_geom wis.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom wis.geometry(MultiPolygon,3979)
)
INHERITS (wis.soundings_2m);


ALTER TABLE wis.soundings_atlantic_2m OWNER TO pgrastertime;

--
-- Name: soundings_vnsl_2m; Type: TABLE; Schema: wis. Owner: pgrastertime
--

CREATE TABLE wis.soundings_vnsl_2m (
    id integer DEFAULT nextval('wis.soundings_2m_id_seq'::regclass),
    tile_id bigint,
    rast wis.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent wis.geometry(Polygon),
    tile_geom wis.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom wis.geometry(MultiPolygon,3979)
)
INHERITS (wis.soundings_2m);


ALTER TABLE wis.soundings_vnsl_2m OWNER TO pgrastertime;

--
-- Name: soundings_western_2m; Type: TABLE; Schema: wis. Owner: pgrastertime
--

CREATE TABLE wis.soundings_western_2m (
    id integer DEFAULT nextval('wis.soundings_2m_id_seq'::regclass),
    tile_id bigint,
    rast wis.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent wis.geometry(Polygon),
    tile_geom wis.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom wis.geometry(MultiPolygon,3979)
)
INHERITS (wis.soundings_2m);


ALTER TABLE wis.soundings_western_2m OWNER TO pgrastertime;

--
-- Name: soundings_2m id; Type: DEFAULT; Schema: wis. Owner: pgrastertime
--

ALTER TABLE ONLY wis.soundings_2m ALTER COLUMN id SET DEFAULT nextval('wis.soundings_2m_id_seq'::regclass);


--
-- Name: soundings_2m soundings_2m_pk; Type: CONSTRAINT; Schema: wis. Owner: pgrastertime
--

ALTER TABLE ONLY wis.soundings_2m
    ADD CONSTRAINT soundings_2m_pk PRIMARY KEY (id);


--
-- Name: soundings_atlantic_2m soundings_atlantic_2m_pkey; Type: CONSTRAINT; Schema: wis. Owner: pgrastertime
--

ALTER TABLE ONLY wis.soundings_atlantic_2m
    ADD CONSTRAINT soundings_atlantic_2m_pkey PRIMARY KEY (id);


--
-- Name: soundings_vnsl_2m soundings_vnsl_2m_pkey; Type: CONSTRAINT; Schema: wis. Owner: pgrastertime
--

ALTER TABLE ONLY wis.soundings_vnsl_2m
    ADD CONSTRAINT soundings_vnsl_2m_pkey PRIMARY KEY (id);


--
-- Name: soundings_western_2m soundings_western_2m_pkey; Type: CONSTRAINT; Schema: wis. Owner: pgrastertime
--

ALTER TABLE ONLY wis.soundings_western_2m
    ADD CONSTRAINT soundings_western_2m_pkey PRIMARY KEY (id);


--
-- Name: soundings_2m_lower_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_2m_lower_sysperiod ON wis.soundings_2m USING btree (lower(sys_period));


--
-- Name: soundings_2m_metadata_id; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_2m_metadata_id ON wis.soundings_2m USING btree (metadata_id);


--
-- Name: soundings_2m_raster; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_2m_raster ON wis.soundings_2m USING gist (wis.st_convexhull(rast));


--
-- Name: soundings_2m_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_2m_sysperiod ON wis.soundings_2m USING gist (sys_period);


--
-- Name: soundings_2m_tile_extent_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_2m_tile_extent_idx ON wis.soundings_2m USING gist (tile_extent);


--
-- Name: soundings_2m_tile_geom_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_2m_tile_geom_idx ON wis.soundings_2m USING gist (tile_geom);


--
-- Name: soundings_atlantic_2m_lower_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_2m_lower_sysperiod ON wis.soundings_atlantic_2m USING btree (lower(sys_period));


--
-- Name: soundings_atlantic_2m_metadata_id; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_2m_metadata_id ON wis.soundings_atlantic_2m USING btree (metadata_id);


--
-- Name: soundings_atlantic_2m_raster; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_2m_raster ON wis.soundings_atlantic_2m USING gist (wis.st_convexhull(rast));


--
-- Name: soundings_atlantic_2m_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_2m_sysperiod ON wis.soundings_atlantic_2m USING gist (sys_period);


--
-- Name: soundings_atlantic_2m_tile_extent_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_2m_tile_extent_idx ON wis.soundings_atlantic_2m USING gist (tile_extent);


--
-- Name: soundings_atlantic_2m_tile_geom_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_2m_tile_geom_idx ON wis.soundings_atlantic_2m USING gist (tile_geom);


--
-- Name: soundings_vnsl_2m_lower_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_2m_lower_sysperiod ON wis.soundings_vnsl_2m USING btree (lower(sys_period));


--
-- Name: soundings_vnsl_2m_metadata_id; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_2m_metadata_id ON wis.soundings_vnsl_2m USING btree (metadata_id);


--
-- Name: soundings_vnsl_2m_raster; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_2m_raster ON wis.soundings_vnsl_2m USING gist (wis.st_convexhull(rast));


--
-- Name: soundings_vnsl_2m_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_2m_sysperiod ON wis.soundings_vnsl_2m USING gist (sys_period);


--
-- Name: soundings_vnsl_2m_tile_extent_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_2m_tile_extent_idx ON wis.soundings_vnsl_2m USING gist (tile_extent);


--
-- Name: soundings_vnsl_2m_tile_geom_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_2m_tile_geom_idx ON wis.soundings_vnsl_2m USING gist (tile_geom);


--
-- Name: soundings_western_2m_lower_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_western_2m_lower_sysperiod ON wis.soundings_western_2m USING btree (lower(sys_period));


--
-- Name: soundings_western_2m_metadata_id; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_western_2m_metadata_id ON wis.soundings_western_2m USING btree (metadata_id);


--
-- Name: soundings_western_2m_raster; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_western_2m_raster ON wis.soundings_western_2m USING gist (wis.st_convexhull(rast));


--
-- Name: soundings_western_2m_sysperiod; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_western_2m_sysperiod ON wis.soundings_western_2m USING gist (sys_period);


--
-- Name: soundings_western_2m_tile_extent_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_western_2m_tile_extent_idx ON wis.soundings_western_2m USING gist (tile_extent);


--
-- Name: soundings_western_2m_tile_geom_idx; Type: INDEX; Schema: wis. Owner: pgrastertime
--

CREATE INDEX soundings_western_2m_tile_geom_idx ON wis.soundings_western_2m USING gist (tile_geom);



