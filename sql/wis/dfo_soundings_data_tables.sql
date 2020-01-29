--
-- PostgreSQL database dump
--

-- Dumped from database version 10.10 (Ubuntu 10.10-0ubuntu0.18.04.1)
-- Dumped by pg_dump version 10.10 (Ubuntu 10.10-0ubuntu0.18.04.1)

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

--
-- Name: soundings_16m; Type: TABLE; Schema: public; Owner: pgrastertime
--

CREATE TABLE public.soundings_16m (
    id integer NOT NULL,
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979),
    CONSTRAINT enforce_nodata_values_rast CHECK ((public._raster_constraint_nodata_values(rast) = '{340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000}'::numeric[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((public.st_numbands(rast) = 4)),
    CONSTRAINT enforce_out_db_rast CHECK ((public._raster_constraint_out_db(rast) = '{f,f,f,f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((public._raster_constraint_pixel_types(rast) = '{32BF,32BF,32BF,32BF}'::text[])),
    CONSTRAINT enforce_scalex_rast CHECK ((round((public.st_scalex(rast))::numeric, 10) = round((16)::numeric, 10))),
    CONSTRAINT enforce_scaley_rast CHECK ((round((public.st_scaley(rast))::numeric, 10) = round((- (16)::numeric), 10))),
    CONSTRAINT enforce_srid_rast CHECK ((public.st_srid(rast) = 3979))
);


ALTER TABLE public.soundings_16m OWNER TO pgrastertime;

--
-- Name: soundings_16m_id_seq; Type: SEQUENCE; Schema: public; Owner: pgrastertime
--

CREATE SEQUENCE public.soundings_16m_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.soundings_16m_id_seq OWNER TO pgrastertime;

--
-- Name: soundings_16m_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgrastertime
--

ALTER SEQUENCE public.soundings_16m_id_seq OWNED BY public.soundings_16m.id;


--
-- Name: soundings_1m; Type: TABLE; Schema: public; Owner: pgrastertime
--

CREATE TABLE public.soundings_1m (
    id integer NOT NULL,
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979),
    CONSTRAINT enforce_nodata_values_rast CHECK ((public._raster_constraint_nodata_values(rast) = '{340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000}'::numeric[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((public.st_numbands(rast) = 4)),
    CONSTRAINT enforce_out_db_rast CHECK ((public._raster_constraint_out_db(rast) = '{f,f,f,f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((public._raster_constraint_pixel_types(rast) = '{32BF,32BF,32BF,32BF}'::text[])),
    CONSTRAINT enforce_scalex_rast CHECK ((round((public.st_scalex(rast))::numeric, 10) = round((1)::numeric, 10))),
    CONSTRAINT enforce_scaley_rast CHECK ((round((public.st_scaley(rast))::numeric, 10) = round((- (1)::numeric), 10))),
    CONSTRAINT enforce_srid_rast CHECK ((public.st_srid(rast) = 3979))
);


ALTER TABLE public.soundings_1m OWNER TO pgrastertime;

--
-- Name: soundings_1m_id_seq; Type: SEQUENCE; Schema: public; Owner: pgrastertime
--

CREATE SEQUENCE public.soundings_1m_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.soundings_1m_id_seq OWNER TO pgrastertime;

--
-- Name: soundings_1m_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgrastertime
--

ALTER SEQUENCE public.soundings_1m_id_seq OWNED BY public.soundings_1m.id;


--
-- Name: soundings_25cm; Type: TABLE; Schema: public; Owner: pgrastertime
--

CREATE TABLE public.soundings_25cm (
    id integer NOT NULL,
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979),
    CONSTRAINT enforce_nodata_values_rast CHECK ((public._raster_constraint_nodata_values(rast) = '{340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000}'::numeric[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((public.st_numbands(rast) = 4)),
    CONSTRAINT enforce_out_db_rast CHECK ((public._raster_constraint_out_db(rast) = '{f,f,f,f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((public._raster_constraint_pixel_types(rast) = '{32BF,32BF,32BF,32BF}'::text[])),
    CONSTRAINT enforce_scalex_rast CHECK ((round((public.st_scalex(rast))::numeric, 10) = round(0.25, 10))),
    CONSTRAINT enforce_scaley_rast CHECK ((round((public.st_scaley(rast))::numeric, 10) = round('-0.25'::numeric, 10))),
    CONSTRAINT enforce_srid_rast CHECK ((public.st_srid(rast) = 3979))
);


ALTER TABLE public.soundings_25cm OWNER TO pgrastertime;

--
-- Name: soundings_25cm_id_seq; Type: SEQUENCE; Schema: public; Owner: pgrastertime
--

CREATE SEQUENCE public.soundings_25cm_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.soundings_25cm_id_seq OWNER TO pgrastertime;

--
-- Name: soundings_25cm_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgrastertime
--

ALTER SEQUENCE public.soundings_25cm_id_seq OWNED BY public.soundings_25cm.id;


--
-- Name: soundings_4m; Type: TABLE; Schema: public; Owner: pgrastertime
--

CREATE TABLE public.soundings_4m (
    id integer NOT NULL,
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979),
    CONSTRAINT enforce_nodata_values_rast CHECK ((public._raster_constraint_nodata_values(rast) = '{340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000}'::numeric[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((public.st_numbands(rast) = 4)),
    CONSTRAINT enforce_out_db_rast CHECK ((public._raster_constraint_out_db(rast) = '{f,f,f,f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((public._raster_constraint_pixel_types(rast) = '{32BF,32BF,32BF,32BF}'::text[])),
    CONSTRAINT enforce_scalex_rast CHECK ((round((public.st_scalex(rast))::numeric, 10) = round((4)::numeric, 10))),
    CONSTRAINT enforce_scaley_rast CHECK ((round((public.st_scaley(rast))::numeric, 10) = round((- (4)::numeric), 10))),
    CONSTRAINT enforce_srid_rast CHECK ((public.st_srid(rast) = 3979))
);


ALTER TABLE public.soundings_4m OWNER TO pgrastertime;

--
-- Name: soundings_4m_id_seq; Type: SEQUENCE; Schema: public; Owner: pgrastertime
--

CREATE SEQUENCE public.soundings_4m_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.soundings_4m_id_seq OWNER TO pgrastertime;

--
-- Name: soundings_4m_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgrastertime
--

ALTER SEQUENCE public.soundings_4m_id_seq OWNED BY public.soundings_4m.id;


--
-- Name: soundings_50cm; Type: TABLE; Schema: public; Owner: pgrastertime
--

CREATE TABLE public.soundings_50cm (
    id integer NOT NULL,
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979),
    CONSTRAINT enforce_nodata_values_rast CHECK ((public._raster_constraint_nodata_values(rast) = '{340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000}'::numeric[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((public.st_numbands(rast) = 4)),
    CONSTRAINT enforce_out_db_rast CHECK ((public._raster_constraint_out_db(rast) = '{f,f,f,f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((public._raster_constraint_pixel_types(rast) = '{32BF,32BF,32BF,32BF}'::text[])),
    CONSTRAINT enforce_scalex_rast CHECK ((round((public.st_scalex(rast))::numeric, 10) = round(0.50, 10))),
    CONSTRAINT enforce_scaley_rast CHECK ((round((public.st_scaley(rast))::numeric, 10) = round('-0.50'::numeric, 10))),
    CONSTRAINT enforce_srid_rast CHECK ((public.st_srid(rast) = 3979))
);


ALTER TABLE public.soundings_50cm OWNER TO pgrastertime;

--
-- Name: soundings_50cm_id_seq; Type: SEQUENCE; Schema: public; Owner: pgrastertime
--

CREATE SEQUENCE public.soundings_50cm_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.soundings_50cm_id_seq OWNER TO pgrastertime;

--
-- Name: soundings_50cm_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgrastertime
--

ALTER SEQUENCE public.soundings_50cm_id_seq OWNED BY public.soundings_50cm.id;


--
-- Name: soundings_8m; Type: TABLE; Schema: public; Owner: pgrastertime
--

CREATE TABLE public.soundings_8m (
    id integer NOT NULL,
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979),
    CONSTRAINT enforce_nodata_values_rast CHECK ((public._raster_constraint_nodata_values(rast) = '{340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000}'::numeric[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((public.st_numbands(rast) = 4)),
    CONSTRAINT enforce_out_db_rast CHECK ((public._raster_constraint_out_db(rast) = '{f,f,f,f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((public._raster_constraint_pixel_types(rast) = '{32BF,32BF,32BF,32BF}'::text[])),
    CONSTRAINT enforce_scalex_rast CHECK ((round((public.st_scalex(rast))::numeric, 10) = round((8)::numeric, 10))),
    CONSTRAINT enforce_scaley_rast CHECK ((round((public.st_scaley(rast))::numeric, 10) = round((- (8)::numeric), 10))),
    CONSTRAINT enforce_srid_rast CHECK ((public.st_srid(rast) = 3979))
);


ALTER TABLE public.soundings_8m OWNER TO pgrastertime;

--
-- Name: soundings_8m_id_seq; Type: SEQUENCE; Schema: public; Owner: pgrastertime
--

CREATE SEQUENCE public.soundings_8m_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.soundings_8m_id_seq OWNER TO pgrastertime;

--
-- Name: soundings_8m_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgrastertime
--

ALTER SEQUENCE public.soundings_8m_id_seq OWNED BY public.soundings_8m.id;


--
-- Name: soundings_atlantic_16m; Type: TABLE; Schema: public; Owner: pgrastertime
--

CREATE TABLE public.soundings_atlantic_16m (
    id integer DEFAULT nextval('public.soundings_16m_id_seq'::regclass),
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979),
    CONSTRAINT enforce_nodata_values_rast CHECK ((public._raster_constraint_nodata_values(rast) = '{340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000}'::numeric[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((public.st_numbands(rast) = 4)),
    CONSTRAINT enforce_out_db_rast CHECK ((public._raster_constraint_out_db(rast) = '{f,f,f,f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((public._raster_constraint_pixel_types(rast) = '{32BF,32BF,32BF,32BF}'::text[])),
    CONSTRAINT enforce_scalex_rast CHECK ((round((public.st_scalex(rast))::numeric, 10) = round((16)::numeric, 10))),
    CONSTRAINT enforce_scaley_rast CHECK ((round((public.st_scaley(rast))::numeric, 10) = round((- (16)::numeric), 10))),
    CONSTRAINT enforce_srid_rast CHECK ((public.st_srid(rast) = 3979))
)
INHERITS (public.soundings_16m);


ALTER TABLE public.soundings_atlantic_16m OWNER TO pgrastertime;

--
-- Name: soundings_atlantic_1m; Type: TABLE; Schema: public; Owner: pgrastertime
--

CREATE TABLE public.soundings_atlantic_1m (
    id integer DEFAULT nextval('public.soundings_1m_id_seq'::regclass),
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979),
    CONSTRAINT enforce_nodata_values_rast CHECK ((public._raster_constraint_nodata_values(rast) = '{340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000}'::numeric[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((public.st_numbands(rast) = 4)),
    CONSTRAINT enforce_out_db_rast CHECK ((public._raster_constraint_out_db(rast) = '{f,f,f,f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((public._raster_constraint_pixel_types(rast) = '{32BF,32BF,32BF,32BF}'::text[])),
    CONSTRAINT enforce_scalex_rast CHECK ((round((public.st_scalex(rast))::numeric, 10) = round((1)::numeric, 10))),
    CONSTRAINT enforce_scaley_rast CHECK ((round((public.st_scaley(rast))::numeric, 10) = round((- (1)::numeric), 10))),
    CONSTRAINT enforce_srid_rast CHECK ((public.st_srid(rast) = 3979))
)
INHERITS (public.soundings_1m);


ALTER TABLE public.soundings_atlantic_1m OWNER TO pgrastertime;

--
-- Name: soundings_atlantic_25cm; Type: TABLE; Schema: public; Owner: pgrastertime
--

CREATE TABLE public.soundings_atlantic_25cm (
    id integer DEFAULT nextval('public.soundings_25cm_id_seq'::regclass),
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979),
    CONSTRAINT enforce_nodata_values_rast CHECK ((public._raster_constraint_nodata_values(rast) = '{340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000}'::numeric[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((public.st_numbands(rast) = 4)),
    CONSTRAINT enforce_out_db_rast CHECK ((public._raster_constraint_out_db(rast) = '{f,f,f,f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((public._raster_constraint_pixel_types(rast) = '{32BF,32BF,32BF,32BF}'::text[])),
    CONSTRAINT enforce_scalex_rast CHECK ((round((public.st_scalex(rast))::numeric, 10) = round(0.25, 10))),
    CONSTRAINT enforce_scaley_rast CHECK ((round((public.st_scaley(rast))::numeric, 10) = round('-0.25'::numeric, 10))),
    CONSTRAINT enforce_srid_rast CHECK ((public.st_srid(rast) = 3979))
)
INHERITS (public.soundings_25cm);


ALTER TABLE public.soundings_atlantic_25cm OWNER TO pgrastertime;

--
-- Name: soundings_atlantic_4m; Type: TABLE; Schema: public; Owner: pgrastertime
--

CREATE TABLE public.soundings_atlantic_4m (
    id integer DEFAULT nextval('public.soundings_4m_id_seq'::regclass),
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979),
    CONSTRAINT enforce_nodata_values_rast CHECK ((public._raster_constraint_nodata_values(rast) = '{340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000}'::numeric[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((public.st_numbands(rast) = 4)),
    CONSTRAINT enforce_out_db_rast CHECK ((public._raster_constraint_out_db(rast) = '{f,f,f,f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((public._raster_constraint_pixel_types(rast) = '{32BF,32BF,32BF,32BF}'::text[])),
    CONSTRAINT enforce_scalex_rast CHECK ((round((public.st_scalex(rast))::numeric, 10) = round((4)::numeric, 10))),
    CONSTRAINT enforce_scaley_rast CHECK ((round((public.st_scaley(rast))::numeric, 10) = round((- (4)::numeric), 10))),
    CONSTRAINT enforce_srid_rast CHECK ((public.st_srid(rast) = 3979))
)
INHERITS (public.soundings_4m);


ALTER TABLE public.soundings_atlantic_4m OWNER TO pgrastertime;

--
-- Name: soundings_atlantic_50cm; Type: TABLE; Schema: public; Owner: pgrastertime
--

CREATE TABLE public.soundings_atlantic_50cm (
    id integer DEFAULT nextval('public.soundings_50cm_id_seq'::regclass),
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979),
    CONSTRAINT enforce_nodata_values_rast CHECK ((public._raster_constraint_nodata_values(rast) = '{340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000}'::numeric[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((public.st_numbands(rast) = 4)),
    CONSTRAINT enforce_out_db_rast CHECK ((public._raster_constraint_out_db(rast) = '{f,f,f,f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((public._raster_constraint_pixel_types(rast) = '{32BF,32BF,32BF,32BF}'::text[])),
    CONSTRAINT enforce_scalex_rast CHECK ((round((public.st_scalex(rast))::numeric, 10) = round(0.50, 10))),
    CONSTRAINT enforce_scaley_rast CHECK ((round((public.st_scaley(rast))::numeric, 10) = round('-0.50'::numeric, 10))),
    CONSTRAINT enforce_srid_rast CHECK ((public.st_srid(rast) = 3979))
)
INHERITS (public.soundings_50cm);


ALTER TABLE public.soundings_atlantic_50cm OWNER TO pgrastertime;

--
-- Name: soundings_atlantic_8m; Type: TABLE; Schema: public; Owner: pgrastertime
--

CREATE TABLE public.soundings_atlantic_8m (
    id integer DEFAULT nextval('public.soundings_8m_id_seq'::regclass),
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979),
    CONSTRAINT enforce_nodata_values_rast CHECK ((public._raster_constraint_nodata_values(rast) = '{340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000}'::numeric[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((public.st_numbands(rast) = 4)),
    CONSTRAINT enforce_out_db_rast CHECK ((public._raster_constraint_out_db(rast) = '{f,f,f,f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((public._raster_constraint_pixel_types(rast) = '{32BF,32BF,32BF,32BF}'::text[])),
    CONSTRAINT enforce_scalex_rast CHECK ((round((public.st_scalex(rast))::numeric, 10) = round((8)::numeric, 10))),
    CONSTRAINT enforce_scaley_rast CHECK ((round((public.st_scaley(rast))::numeric, 10) = round((- (8)::numeric), 10))),
    CONSTRAINT enforce_srid_rast CHECK ((public.st_srid(rast) = 3979))
)
INHERITS (public.soundings_8m);


ALTER TABLE public.soundings_atlantic_8m OWNER TO pgrastertime;

--
-- Name: soundings_vnsl_16m; Type: TABLE; Schema: public; Owner: pgrastertime
--

CREATE TABLE public.soundings_vnsl_16m (
    id integer DEFAULT nextval('public.soundings_16m_id_seq'::regclass),
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979),
    CONSTRAINT enforce_nodata_values_rast CHECK ((public._raster_constraint_nodata_values(rast) = '{340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000}'::numeric[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((public.st_numbands(rast) = 4)),
    CONSTRAINT enforce_out_db_rast CHECK ((public._raster_constraint_out_db(rast) = '{f,f,f,f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((public._raster_constraint_pixel_types(rast) = '{32BF,32BF,32BF,32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (public.st_samealignment(rast, '0100000000000000000000304000000000000030C000000000209C39410000000000A0E9C0000000000000000000000000000000008B0F000001000100'::public.raster)),
    CONSTRAINT enforce_scalex_rast CHECK ((round((public.st_scalex(rast))::numeric, 10) = round((16)::numeric, 10))),
    CONSTRAINT enforce_scaley_rast CHECK ((round((public.st_scaley(rast))::numeric, 10) = round((- (16)::numeric), 10))),
    CONSTRAINT enforce_srid_rast CHECK ((public.st_srid(rast) = 3979))
)
INHERITS (public.soundings_16m);


ALTER TABLE public.soundings_vnsl_16m OWNER TO pgrastertime;

--
-- Name: soundings_vnsl_1m; Type: TABLE; Schema: public; Owner: pgrastertime
--

CREATE TABLE public.soundings_vnsl_1m (
    id integer DEFAULT nextval('public.soundings_1m_id_seq'::regclass),
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979),
    CONSTRAINT enforce_nodata_values_rast CHECK ((public._raster_constraint_nodata_values(rast) = '{340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000}'::numeric[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((public.st_numbands(rast) = 4)),
    CONSTRAINT enforce_out_db_rast CHECK ((public._raster_constraint_out_db(rast) = '{f,f,f,f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((public._raster_constraint_pixel_types(rast) = '{32BF,32BF,32BF,32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (public.st_samealignment(rast, '0100000000000000000000F03F000000000000F0BF00000000DF7B3941000000003078F8C0000000000000000000000000000000008B0F000001000100'::public.raster)),
    CONSTRAINT enforce_scalex_rast CHECK ((round((public.st_scalex(rast))::numeric, 10) = round((1)::numeric, 10))),
    CONSTRAINT enforce_scaley_rast CHECK ((round((public.st_scaley(rast))::numeric, 10) = round((- (1)::numeric), 10))),
    CONSTRAINT enforce_srid_rast CHECK ((public.st_srid(rast) = 3979))
)
INHERITS (public.soundings_1m);


ALTER TABLE public.soundings_vnsl_1m OWNER TO pgrastertime;

--
-- Name: soundings_vnsl_25cm; Type: TABLE; Schema: public; Owner: pgrastertime
--

CREATE TABLE public.soundings_vnsl_25cm (
    id integer DEFAULT nextval('public.soundings_25cm_id_seq'::regclass),
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979),
    CONSTRAINT enforce_nodata_values_rast CHECK ((public._raster_constraint_nodata_values(rast) = '{340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000}'::numeric[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((public.st_numbands(rast) = 4)),
    CONSTRAINT enforce_out_db_rast CHECK ((public._raster_constraint_out_db(rast) = '{f,f,f,f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((public._raster_constraint_pixel_types(rast) = '{32BF,32BF,32BF,32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (public.st_samealignment(rast, '0100000000000000000000D03F000000000000D0BF000000C0ED793941000000007C4DF6C0000000000000000000000000000000008B0F000001000100'::public.raster)),
    CONSTRAINT enforce_scalex_rast CHECK ((round((public.st_scalex(rast))::numeric, 10) = round(0.25, 10))),
    CONSTRAINT enforce_scaley_rast CHECK ((round((public.st_scaley(rast))::numeric, 10) = round('-0.25'::numeric, 10))),
    CONSTRAINT enforce_srid_rast CHECK ((public.st_srid(rast) = 3979))
)
INHERITS (public.soundings_25cm);


ALTER TABLE public.soundings_vnsl_25cm OWNER TO pgrastertime;

--
-- Name: soundings_vnsl_4m; Type: TABLE; Schema: public; Owner: pgrastertime
--

CREATE TABLE public.soundings_vnsl_4m (
    id integer DEFAULT nextval('public.soundings_4m_id_seq'::regclass),
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979),
    CONSTRAINT enforce_nodata_values_rast CHECK ((public._raster_constraint_nodata_values(rast) = '{340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000}'::numeric[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((public.st_numbands(rast) = 4)),
    CONSTRAINT enforce_out_db_rast CHECK ((public._raster_constraint_out_db(rast) = '{f,f,f,f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((public._raster_constraint_pixel_types(rast) = '{32BF,32BF,32BF,32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (public.st_samealignment(rast, '0100000000000000000000104000000000000010C000000000FC7A39410000000000B1F8C0000000000000000000000000000000008B0F000001000100'::public.raster)),
    CONSTRAINT enforce_scalex_rast CHECK ((round((public.st_scalex(rast))::numeric, 10) = round((4)::numeric, 10))),
    CONSTRAINT enforce_scaley_rast CHECK ((round((public.st_scaley(rast))::numeric, 10) = round((- (4)::numeric), 10))),
    CONSTRAINT enforce_srid_rast CHECK ((public.st_srid(rast) = 3979))
)
INHERITS (public.soundings_4m);
ALTER TABLE ONLY public.soundings_vnsl_4m ALTER COLUMN rast SET STORAGE EXTERNAL;


ALTER TABLE public.soundings_vnsl_4m OWNER TO pgrastertime;

--
-- Name: soundings_vnsl_50cm; Type: TABLE; Schema: public; Owner: pgrastertime
--

CREATE TABLE public.soundings_vnsl_50cm (
    id integer DEFAULT nextval('public.soundings_50cm_id_seq'::regclass),
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979),
    CONSTRAINT enforce_nodata_values_rast CHECK ((public._raster_constraint_nodata_values(rast) = '{340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000}'::numeric[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((public.st_numbands(rast) = 4)),
    CONSTRAINT enforce_out_db_rast CHECK ((public._raster_constraint_out_db(rast) = '{f,f,f,f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((public._raster_constraint_pixel_types(rast) = '{32BF,32BF,32BF,32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (public.st_samealignment(rast, '0100000000000000000000E03F000000000000E0BF000000004E9A3941000000002099E7C0000000000000000000000000000000008B0F000001000100'::public.raster)),
    CONSTRAINT enforce_scalex_rast CHECK ((round((public.st_scalex(rast))::numeric, 10) = round(0.50, 10))),
    CONSTRAINT enforce_scaley_rast CHECK ((round((public.st_scaley(rast))::numeric, 10) = round('-0.50'::numeric, 10))),
    CONSTRAINT enforce_srid_rast CHECK ((public.st_srid(rast) = 3979))
)
INHERITS (public.soundings_50cm);


ALTER TABLE public.soundings_vnsl_50cm OWNER TO pgrastertime;

--
-- Name: soundings_vnsl_8m; Type: TABLE; Schema: public; Owner: pgrastertime
--

CREATE TABLE public.soundings_vnsl_8m (
    id integer DEFAULT nextval('public.soundings_8m_id_seq'::regclass),
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979),
    CONSTRAINT enforce_nodata_values_rast CHECK ((public._raster_constraint_nodata_values(rast) = '{340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000}'::numeric[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((public.st_numbands(rast) = 4)),
    CONSTRAINT enforce_out_db_rast CHECK ((public._raster_constraint_out_db(rast) = '{f,f,f,f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((public._raster_constraint_pixel_types(rast) = '{32BF,32BF,32BF,32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (public.st_samealignment(rast, '0100000000000000000000204000000000000020C00000000048763941000000000047F9C0000000000000000000000000000000008B0F000001000100'::public.raster)),
    CONSTRAINT enforce_scalex_rast CHECK ((round((public.st_scalex(rast))::numeric, 10) = round((8)::numeric, 10))),
    CONSTRAINT enforce_scaley_rast CHECK ((round((public.st_scaley(rast))::numeric, 10) = round((- (8)::numeric), 10))),
    CONSTRAINT enforce_srid_rast CHECK ((public.st_srid(rast) = 3979))
)
INHERITS (public.soundings_8m);


ALTER TABLE public.soundings_vnsl_8m OWNER TO pgrastertime;

--
-- Name: soundings_western_16m; Type: TABLE; Schema: public; Owner: pgrastertime
--

CREATE TABLE public.soundings_western_16m (
    id integer DEFAULT nextval('public.soundings_16m_id_seq'::regclass),
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979),
    CONSTRAINT enforce_nodata_values_rast CHECK ((public._raster_constraint_nodata_values(rast) = '{340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000}'::numeric[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((public.st_numbands(rast) = 4)),
    CONSTRAINT enforce_out_db_rast CHECK ((public._raster_constraint_out_db(rast) = '{f,f,f,f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((public._raster_constraint_pixel_types(rast) = '{32BF,32BF,32BF,32BF}'::text[])),
    CONSTRAINT enforce_scalex_rast CHECK ((round((public.st_scalex(rast))::numeric, 10) = round((16)::numeric, 10))),
    CONSTRAINT enforce_scaley_rast CHECK ((round((public.st_scaley(rast))::numeric, 10) = round((- (16)::numeric), 10))),
    CONSTRAINT enforce_srid_rast CHECK ((public.st_srid(rast) = 3979))
)
INHERITS (public.soundings_16m);


ALTER TABLE public.soundings_western_16m OWNER TO pgrastertime;

--
-- Name: soundings_western_1m; Type: TABLE; Schema: public; Owner: pgrastertime
--

CREATE TABLE public.soundings_western_1m (
    id integer DEFAULT nextval('public.soundings_1m_id_seq'::regclass),
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979),
    CONSTRAINT enforce_nodata_values_rast CHECK ((public._raster_constraint_nodata_values(rast) = '{340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000}'::numeric[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((public.st_numbands(rast) = 4)),
    CONSTRAINT enforce_out_db_rast CHECK ((public._raster_constraint_out_db(rast) = '{f,f,f,f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((public._raster_constraint_pixel_types(rast) = '{32BF,32BF,32BF,32BF}'::text[])),
    CONSTRAINT enforce_scalex_rast CHECK ((round((public.st_scalex(rast))::numeric, 10) = round((1)::numeric, 10))),
    CONSTRAINT enforce_scaley_rast CHECK ((round((public.st_scaley(rast))::numeric, 10) = round((- (1)::numeric), 10))),
    CONSTRAINT enforce_srid_rast CHECK ((public.st_srid(rast) = 3979))
)
INHERITS (public.soundings_1m);


ALTER TABLE public.soundings_western_1m OWNER TO pgrastertime;

--
-- Name: soundings_western_25cm; Type: TABLE; Schema: public; Owner: pgrastertime
--

CREATE TABLE public.soundings_western_25cm (
    id integer DEFAULT nextval('public.soundings_25cm_id_seq'::regclass),
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979),
    CONSTRAINT enforce_nodata_values_rast CHECK ((public._raster_constraint_nodata_values(rast) = '{340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000}'::numeric[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((public.st_numbands(rast) = 4)),
    CONSTRAINT enforce_out_db_rast CHECK ((public._raster_constraint_out_db(rast) = '{f,f,f,f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((public._raster_constraint_pixel_types(rast) = '{32BF,32BF,32BF,32BF}'::text[])),
    CONSTRAINT enforce_scalex_rast CHECK ((round((public.st_scalex(rast))::numeric, 10) = round(0.25, 10))),
    CONSTRAINT enforce_scaley_rast CHECK ((round((public.st_scaley(rast))::numeric, 10) = round('-0.25'::numeric, 10))),
    CONSTRAINT enforce_srid_rast CHECK ((public.st_srid(rast) = 3979))
)
INHERITS (public.soundings_25cm);


ALTER TABLE public.soundings_western_25cm OWNER TO pgrastertime;

--
-- Name: soundings_western_4m; Type: TABLE; Schema: public; Owner: pgrastertime
--

CREATE TABLE public.soundings_western_4m (
    id integer DEFAULT nextval('public.soundings_4m_id_seq'::regclass),
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979),
    CONSTRAINT enforce_nodata_values_rast CHECK ((public._raster_constraint_nodata_values(rast) = '{340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000}'::numeric[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((public.st_numbands(rast) = 4)),
    CONSTRAINT enforce_out_db_rast CHECK ((public._raster_constraint_out_db(rast) = '{f,f,f,f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((public._raster_constraint_pixel_types(rast) = '{32BF,32BF,32BF,32BF}'::text[])),
    CONSTRAINT enforce_scalex_rast CHECK ((round((public.st_scalex(rast))::numeric, 10) = round((4)::numeric, 10))),
    CONSTRAINT enforce_scaley_rast CHECK ((round((public.st_scaley(rast))::numeric, 10) = round((- (4)::numeric), 10))),
    CONSTRAINT enforce_srid_rast CHECK ((public.st_srid(rast) = 3979))
)
INHERITS (public.soundings_4m);


ALTER TABLE public.soundings_western_4m OWNER TO pgrastertime;

--
-- Name: soundings_western_50cm; Type: TABLE; Schema: public; Owner: pgrastertime
--

CREATE TABLE public.soundings_western_50cm (
    id integer DEFAULT nextval('public.soundings_50cm_id_seq'::regclass),
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979),
    CONSTRAINT enforce_nodata_values_rast CHECK ((public._raster_constraint_nodata_values(rast) = '{340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000}'::numeric[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((public.st_numbands(rast) = 4)),
    CONSTRAINT enforce_out_db_rast CHECK ((public._raster_constraint_out_db(rast) = '{f,f,f,f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((public._raster_constraint_pixel_types(rast) = '{32BF,32BF,32BF,32BF}'::text[])),
    CONSTRAINT enforce_scalex_rast CHECK ((round((public.st_scalex(rast))::numeric, 10) = round(0.50, 10))),
    CONSTRAINT enforce_scaley_rast CHECK ((round((public.st_scaley(rast))::numeric, 10) = round('-0.50'::numeric, 10))),
    CONSTRAINT enforce_srid_rast CHECK ((public.st_srid(rast) = 3979))
)
INHERITS (public.soundings_50cm);


ALTER TABLE public.soundings_western_50cm OWNER TO pgrastertime;

--
-- Name: soundings_western_8m; Type: TABLE; Schema: public; Owner: pgrastertime
--

CREATE TABLE public.soundings_western_8m (
    id integer DEFAULT nextval('public.soundings_8m_id_seq'::regclass),
    tile_id bigint,
    rast public.raster,
    resolution double precision,
    filename text,
    sys_period tstzrange,
    tile_extent public.geometry(Polygon),
    tile_geom public.geometry(MultiPolygon),
    metadata_id character varying(100),
    shoal_geom public.geometry(MultiPolygon,3979),
    CONSTRAINT enforce_nodata_values_rast CHECK ((public._raster_constraint_nodata_values(rast) = '{340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000}'::numeric[])),
    CONSTRAINT enforce_num_bands_rast CHECK ((public.st_numbands(rast) = 4)),
    CONSTRAINT enforce_out_db_rast CHECK ((public._raster_constraint_out_db(rast) = '{f,f,f,f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((public._raster_constraint_pixel_types(rast) = '{32BF,32BF,32BF,32BF}'::text[])),
    CONSTRAINT enforce_scalex_rast CHECK ((round((public.st_scalex(rast))::numeric, 10) = round((8)::numeric, 10))),
    CONSTRAINT enforce_scaley_rast CHECK ((round((public.st_scaley(rast))::numeric, 10) = round((- (8)::numeric), 10))),
    CONSTRAINT enforce_srid_rast CHECK ((public.st_srid(rast) = 3979))
)
INHERITS (public.soundings_8m);


ALTER TABLE public.soundings_western_8m OWNER TO pgrastertime;

--
-- Name: soundings_16m id; Type: DEFAULT; Schema: public; Owner: pgrastertime
--

ALTER TABLE ONLY public.soundings_16m ALTER COLUMN id SET DEFAULT nextval('public.soundings_16m_id_seq'::regclass);


--
-- Name: soundings_1m id; Type: DEFAULT; Schema: public; Owner: pgrastertime
--

ALTER TABLE ONLY public.soundings_1m ALTER COLUMN id SET DEFAULT nextval('public.soundings_1m_id_seq'::regclass);


--
-- Name: soundings_25cm id; Type: DEFAULT; Schema: public; Owner: pgrastertime
--

ALTER TABLE ONLY public.soundings_25cm ALTER COLUMN id SET DEFAULT nextval('public.soundings_25cm_id_seq'::regclass);


--
-- Name: soundings_4m id; Type: DEFAULT; Schema: public; Owner: pgrastertime
--

ALTER TABLE ONLY public.soundings_4m ALTER COLUMN id SET DEFAULT nextval('public.soundings_4m_id_seq'::regclass);


--
-- Name: soundings_50cm id; Type: DEFAULT; Schema: public; Owner: pgrastertime
--

ALTER TABLE ONLY public.soundings_50cm ALTER COLUMN id SET DEFAULT nextval('public.soundings_50cm_id_seq'::regclass);


--
-- Name: soundings_8m id; Type: DEFAULT; Schema: public; Owner: pgrastertime
--

ALTER TABLE ONLY public.soundings_8m ALTER COLUMN id SET DEFAULT nextval('public.soundings_8m_id_seq'::regclass);


--
-- Name: soundings_16m soundings_16m_pk; Type: CONSTRAINT; Schema: public; Owner: pgrastertime
--

ALTER TABLE ONLY public.soundings_16m
    ADD CONSTRAINT soundings_16m_pk PRIMARY KEY (id);


--
-- Name: soundings_1m soundings_1m_pk; Type: CONSTRAINT; Schema: public; Owner: pgrastertime
--

ALTER TABLE ONLY public.soundings_1m
    ADD CONSTRAINT soundings_1m_pk PRIMARY KEY (id);


--
-- Name: soundings_25cm soundings_25cm_pk; Type: CONSTRAINT; Schema: public; Owner: pgrastertime
--

ALTER TABLE ONLY public.soundings_25cm
    ADD CONSTRAINT soundings_25cm_pk PRIMARY KEY (id);


--
-- Name: soundings_4m soundings_4m_pk; Type: CONSTRAINT; Schema: public; Owner: pgrastertime
--

ALTER TABLE ONLY public.soundings_4m
    ADD CONSTRAINT soundings_4m_pk PRIMARY KEY (id);


--
-- Name: soundings_50cm soundings_50cm_pk; Type: CONSTRAINT; Schema: public; Owner: pgrastertime
--

ALTER TABLE ONLY public.soundings_50cm
    ADD CONSTRAINT soundings_50cm_pk PRIMARY KEY (id);


--
-- Name: soundings_8m soundings_8m_pk; Type: CONSTRAINT; Schema: public; Owner: pgrastertime
--

ALTER TABLE ONLY public.soundings_8m
    ADD CONSTRAINT soundings_8m_pk PRIMARY KEY (id);


--
-- Name: soundings_atlantic_16m soundings_atlantic_16m_pkey; Type: CONSTRAINT; Schema: public; Owner: pgrastertime
--

ALTER TABLE ONLY public.soundings_atlantic_16m
    ADD CONSTRAINT soundings_atlantic_16m_pkey PRIMARY KEY (id);


--
-- Name: soundings_atlantic_1m soundings_atlantic_1m_pkey; Type: CONSTRAINT; Schema: public; Owner: pgrastertime
--

ALTER TABLE ONLY public.soundings_atlantic_1m
    ADD CONSTRAINT soundings_atlantic_1m_pkey PRIMARY KEY (id);


--
-- Name: soundings_atlantic_25cm soundings_atlantic_25cm_pkey; Type: CONSTRAINT; Schema: public; Owner: pgrastertime
--

ALTER TABLE ONLY public.soundings_atlantic_25cm
    ADD CONSTRAINT soundings_atlantic_25cm_pkey PRIMARY KEY (id);


--
-- Name: soundings_atlantic_4m soundings_atlantic_4m_pkey; Type: CONSTRAINT; Schema: public; Owner: pgrastertime
--

ALTER TABLE ONLY public.soundings_atlantic_4m
    ADD CONSTRAINT soundings_atlantic_4m_pkey PRIMARY KEY (id);


--
-- Name: soundings_atlantic_50cm soundings_atlantic_50cm_pkey; Type: CONSTRAINT; Schema: public; Owner: pgrastertime
--

ALTER TABLE ONLY public.soundings_atlantic_50cm
    ADD CONSTRAINT soundings_atlantic_50cm_pkey PRIMARY KEY (id);


--
-- Name: soundings_atlantic_8m soundings_atlantic_8m_pkey; Type: CONSTRAINT; Schema: public; Owner: pgrastertime
--

ALTER TABLE ONLY public.soundings_atlantic_8m
    ADD CONSTRAINT soundings_atlantic_8m_pkey PRIMARY KEY (id);


--
-- Name: soundings_vnsl_16m soundings_vnsl_16m_pkey; Type: CONSTRAINT; Schema: public; Owner: pgrastertime
--

ALTER TABLE ONLY public.soundings_vnsl_16m
    ADD CONSTRAINT soundings_vnsl_16m_pkey PRIMARY KEY (id);


--
-- Name: soundings_vnsl_1m soundings_vnsl_1m_pkey; Type: CONSTRAINT; Schema: public; Owner: pgrastertime
--

ALTER TABLE ONLY public.soundings_vnsl_1m
    ADD CONSTRAINT soundings_vnsl_1m_pkey PRIMARY KEY (id);


--
-- Name: soundings_vnsl_25cm soundings_vnsl_25cm_pkey; Type: CONSTRAINT; Schema: public; Owner: pgrastertime
--

ALTER TABLE ONLY public.soundings_vnsl_25cm
    ADD CONSTRAINT soundings_vnsl_25cm_pkey PRIMARY KEY (id);


--
-- Name: soundings_vnsl_4m soundings_vnsl_4m_pkey; Type: CONSTRAINT; Schema: public; Owner: pgrastertime
--

ALTER TABLE ONLY public.soundings_vnsl_4m
    ADD CONSTRAINT soundings_vnsl_4m_pkey PRIMARY KEY (id);


--
-- Name: soundings_vnsl_50cm soundings_vnsl_50cm_pkey; Type: CONSTRAINT; Schema: public; Owner: pgrastertime
--

ALTER TABLE ONLY public.soundings_vnsl_50cm
    ADD CONSTRAINT soundings_vnsl_50cm_pkey PRIMARY KEY (id);


--
-- Name: soundings_vnsl_8m soundings_vnsl_8m_pkey; Type: CONSTRAINT; Schema: public; Owner: pgrastertime
--

ALTER TABLE ONLY public.soundings_vnsl_8m
    ADD CONSTRAINT soundings_vnsl_8m_pkey PRIMARY KEY (id);


--
-- Name: soundings_western_16m soundings_western_16m_pkey; Type: CONSTRAINT; Schema: public; Owner: pgrastertime
--

ALTER TABLE ONLY public.soundings_western_16m
    ADD CONSTRAINT soundings_western_16m_pkey PRIMARY KEY (id);


--
-- Name: soundings_western_1m soundings_western_1m_pkey; Type: CONSTRAINT; Schema: public; Owner: pgrastertime
--

ALTER TABLE ONLY public.soundings_western_1m
    ADD CONSTRAINT soundings_western_1m_pkey PRIMARY KEY (id);


--
-- Name: soundings_western_25cm soundings_western_25cm_pkey; Type: CONSTRAINT; Schema: public; Owner: pgrastertime
--

ALTER TABLE ONLY public.soundings_western_25cm
    ADD CONSTRAINT soundings_western_25cm_pkey PRIMARY KEY (id);


--
-- Name: soundings_western_4m soundings_western_4m_pkey; Type: CONSTRAINT; Schema: public; Owner: pgrastertime
--

ALTER TABLE ONLY public.soundings_western_4m
    ADD CONSTRAINT soundings_western_4m_pkey PRIMARY KEY (id);


--
-- Name: soundings_western_50cm soundings_western_50cm_pkey; Type: CONSTRAINT; Schema: public; Owner: pgrastertime
--

ALTER TABLE ONLY public.soundings_western_50cm
    ADD CONSTRAINT soundings_western_50cm_pkey PRIMARY KEY (id);


--
-- Name: soundings_western_8m soundings_western_8m_pkey; Type: CONSTRAINT; Schema: public; Owner: pgrastertime
--

ALTER TABLE ONLY public.soundings_western_8m
    ADD CONSTRAINT soundings_western_8m_pkey PRIMARY KEY (id);


--
-- Name: soundings_16m_lower_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_16m_lower_sysperiod ON public.soundings_16m USING btree (lower(sys_period));


--
-- Name: soundings_16m_metadata_id; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_16m_metadata_id ON public.soundings_16m USING btree (metadata_id);


--
-- Name: soundings_16m_raster; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_16m_raster ON public.soundings_16m USING gist (public.st_convexhull(rast));


--
-- Name: soundings_16m_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_16m_sysperiod ON public.soundings_16m USING gist (sys_period);


--
-- Name: soundings_16m_tile_extent_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_16m_tile_extent_idx ON public.soundings_16m USING gist (tile_extent);


--
-- Name: soundings_16m_tile_geom_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_16m_tile_geom_idx ON public.soundings_16m USING gist (tile_geom);


--
-- Name: soundings_1m_lower_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_1m_lower_sysperiod ON public.soundings_1m USING btree (lower(sys_period));


--
-- Name: soundings_1m_metadata_id; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_1m_metadata_id ON public.soundings_1m USING btree (metadata_id);


--
-- Name: soundings_1m_raster; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_1m_raster ON public.soundings_1m USING gist (public.st_convexhull(rast));


--
-- Name: soundings_1m_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_1m_sysperiod ON public.soundings_1m USING gist (sys_period);


--
-- Name: soundings_1m_tile_extent_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_1m_tile_extent_idx ON public.soundings_1m USING gist (tile_extent);


--
-- Name: soundings_1m_tile_geom_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_1m_tile_geom_idx ON public.soundings_1m USING gist (tile_geom);


--
-- Name: soundings_25cm_lower_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_25cm_lower_sysperiod ON public.soundings_25cm USING btree (lower(sys_period));


--
-- Name: soundings_25cm_metadata_id; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_25cm_metadata_id ON public.soundings_25cm USING btree (metadata_id);


--
-- Name: soundings_25cm_raster; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_25cm_raster ON public.soundings_25cm USING gist (public.st_convexhull(rast));


--
-- Name: soundings_25cm_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_25cm_sysperiod ON public.soundings_25cm USING gist (sys_period);


--
-- Name: soundings_25cm_tile_extent_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_25cm_tile_extent_idx ON public.soundings_25cm USING gist (tile_extent);


--
-- Name: soundings_25cm_tile_geom_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_25cm_tile_geom_idx ON public.soundings_25cm USING gist (tile_geom);


--
-- Name: soundings_4m_lower_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_4m_lower_sysperiod ON public.soundings_4m USING btree (lower(sys_period));


--
-- Name: soundings_4m_metadata_id; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_4m_metadata_id ON public.soundings_4m USING btree (metadata_id);


--
-- Name: soundings_4m_raster; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_4m_raster ON public.soundings_4m USING gist (public.st_convexhull(rast));


--
-- Name: soundings_4m_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_4m_sysperiod ON public.soundings_4m USING gist (sys_period);


--
-- Name: soundings_4m_tile_extent_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_4m_tile_extent_idx ON public.soundings_4m USING gist (tile_extent);


--
-- Name: soundings_4m_tile_geom_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_4m_tile_geom_idx ON public.soundings_4m USING gist (tile_geom);


--
-- Name: soundings_50cm_lower_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_50cm_lower_sysperiod ON public.soundings_50cm USING btree (lower(sys_period));


--
-- Name: soundings_50cm_metadata_id; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_50cm_metadata_id ON public.soundings_50cm USING btree (metadata_id);


--
-- Name: soundings_50cm_raster; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_50cm_raster ON public.soundings_50cm USING gist (public.st_convexhull(rast));


--
-- Name: soundings_50cm_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_50cm_sysperiod ON public.soundings_50cm USING gist (sys_period);


--
-- Name: soundings_50cm_tile_extent_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_50cm_tile_extent_idx ON public.soundings_50cm USING gist (tile_extent);


--
-- Name: soundings_50cm_tile_geom_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_50cm_tile_geom_idx ON public.soundings_50cm USING gist (tile_geom);


--
-- Name: soundings_8m_lower_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_8m_lower_sysperiod ON public.soundings_8m USING btree (lower(sys_period));


--
-- Name: soundings_8m_metadata_id; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_8m_metadata_id ON public.soundings_8m USING btree (metadata_id);


--
-- Name: soundings_8m_raster; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_8m_raster ON public.soundings_8m USING gist (public.st_convexhull(rast));


--
-- Name: soundings_8m_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_8m_sysperiod ON public.soundings_8m USING gist (sys_period);


--
-- Name: soundings_8m_tile_extent_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_8m_tile_extent_idx ON public.soundings_8m USING gist (tile_extent);


--
-- Name: soundings_8m_tile_geom_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_8m_tile_geom_idx ON public.soundings_8m USING gist (tile_geom);


--
-- Name: soundings_atlantic_16m_lower_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_16m_lower_sysperiod ON public.soundings_atlantic_16m USING btree (lower(sys_period));


--
-- Name: soundings_atlantic_16m_metadata_id; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_16m_metadata_id ON public.soundings_atlantic_16m USING btree (metadata_id);


--
-- Name: soundings_atlantic_16m_raster; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_16m_raster ON public.soundings_atlantic_16m USING gist (public.st_convexhull(rast));


--
-- Name: soundings_atlantic_16m_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_16m_sysperiod ON public.soundings_atlantic_16m USING gist (sys_period);


--
-- Name: soundings_atlantic_16m_tile_extent_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_16m_tile_extent_idx ON public.soundings_atlantic_16m USING gist (tile_extent);


--
-- Name: soundings_atlantic_16m_tile_geom_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_16m_tile_geom_idx ON public.soundings_atlantic_16m USING gist (tile_geom);


--
-- Name: soundings_atlantic_1m_lower_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_1m_lower_sysperiod ON public.soundings_atlantic_1m USING btree (lower(sys_period));


--
-- Name: soundings_atlantic_1m_metadata_id; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_1m_metadata_id ON public.soundings_atlantic_1m USING btree (metadata_id);


--
-- Name: soundings_atlantic_1m_raster; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_1m_raster ON public.soundings_atlantic_1m USING gist (public.st_convexhull(rast));


--
-- Name: soundings_atlantic_1m_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_1m_sysperiod ON public.soundings_atlantic_1m USING gist (sys_period);


--
-- Name: soundings_atlantic_1m_tile_extent_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_1m_tile_extent_idx ON public.soundings_atlantic_1m USING gist (tile_extent);


--
-- Name: soundings_atlantic_1m_tile_geom_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_1m_tile_geom_idx ON public.soundings_atlantic_1m USING gist (tile_geom);


--
-- Name: soundings_atlantic_25cm_lower_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_25cm_lower_sysperiod ON public.soundings_atlantic_25cm USING btree (lower(sys_period));


--
-- Name: soundings_atlantic_25cm_metadata_id; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_25cm_metadata_id ON public.soundings_atlantic_25cm USING btree (metadata_id);


--
-- Name: soundings_atlantic_25cm_raster; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_25cm_raster ON public.soundings_atlantic_25cm USING gist (public.st_convexhull(rast));


--
-- Name: soundings_atlantic_25cm_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_25cm_sysperiod ON public.soundings_atlantic_25cm USING gist (sys_period);


--
-- Name: soundings_atlantic_25cm_tile_extent_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_25cm_tile_extent_idx ON public.soundings_atlantic_25cm USING gist (tile_extent);


--
-- Name: soundings_atlantic_25cm_tile_geom_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_25cm_tile_geom_idx ON public.soundings_atlantic_25cm USING gist (tile_geom);


--
-- Name: soundings_atlantic_4m_lower_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_4m_lower_sysperiod ON public.soundings_atlantic_4m USING btree (lower(sys_period));


--
-- Name: soundings_atlantic_4m_metadata_id; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_4m_metadata_id ON public.soundings_atlantic_4m USING btree (metadata_id);


--
-- Name: soundings_atlantic_4m_raster; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_4m_raster ON public.soundings_atlantic_4m USING gist (public.st_convexhull(rast));


--
-- Name: soundings_atlantic_4m_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_4m_sysperiod ON public.soundings_atlantic_4m USING gist (sys_period);


--
-- Name: soundings_atlantic_4m_tile_extent_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_4m_tile_extent_idx ON public.soundings_atlantic_4m USING gist (tile_extent);


--
-- Name: soundings_atlantic_4m_tile_geom_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_4m_tile_geom_idx ON public.soundings_atlantic_4m USING gist (tile_geom);


--
-- Name: soundings_atlantic_50cm_lower_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_50cm_lower_sysperiod ON public.soundings_atlantic_50cm USING btree (lower(sys_period));


--
-- Name: soundings_atlantic_50cm_metadata_id; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_50cm_metadata_id ON public.soundings_atlantic_50cm USING btree (metadata_id);


--
-- Name: soundings_atlantic_50cm_raster; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_50cm_raster ON public.soundings_atlantic_50cm USING gist (public.st_convexhull(rast));


--
-- Name: soundings_atlantic_50cm_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_50cm_sysperiod ON public.soundings_atlantic_50cm USING gist (sys_period);


--
-- Name: soundings_atlantic_50cm_tile_extent_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_50cm_tile_extent_idx ON public.soundings_atlantic_50cm USING gist (tile_extent);


--
-- Name: soundings_atlantic_50cm_tile_geom_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_50cm_tile_geom_idx ON public.soundings_atlantic_50cm USING gist (tile_geom);


--
-- Name: soundings_atlantic_8m_lower_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_8m_lower_sysperiod ON public.soundings_atlantic_8m USING btree (lower(sys_period));


--
-- Name: soundings_atlantic_8m_metadata_id; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_8m_metadata_id ON public.soundings_atlantic_8m USING btree (metadata_id);


--
-- Name: soundings_atlantic_8m_raster; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_8m_raster ON public.soundings_atlantic_8m USING gist (public.st_convexhull(rast));


--
-- Name: soundings_atlantic_8m_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_8m_sysperiod ON public.soundings_atlantic_8m USING gist (sys_period);


--
-- Name: soundings_atlantic_8m_tile_extent_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_8m_tile_extent_idx ON public.soundings_atlantic_8m USING gist (tile_extent);


--
-- Name: soundings_atlantic_8m_tile_geom_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_atlantic_8m_tile_geom_idx ON public.soundings_atlantic_8m USING gist (tile_geom);


--
-- Name: soundings_vnsl_16m_lower_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_16m_lower_sysperiod ON public.soundings_vnsl_16m USING btree (lower(sys_period));


--
-- Name: soundings_vnsl_16m_metadata_id; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_16m_metadata_id ON public.soundings_vnsl_16m USING btree (metadata_id);


--
-- Name: soundings_vnsl_16m_raster; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_16m_raster ON public.soundings_vnsl_16m USING gist (public.st_convexhull(rast));


--
-- Name: soundings_vnsl_16m_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_16m_sysperiod ON public.soundings_vnsl_16m USING gist (sys_period);


--
-- Name: soundings_vnsl_16m_tile_extent_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_16m_tile_extent_idx ON public.soundings_vnsl_16m USING gist (tile_extent);


--
-- Name: soundings_vnsl_16m_tile_geom_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_16m_tile_geom_idx ON public.soundings_vnsl_16m USING gist (tile_geom);


--
-- Name: soundings_vnsl_1m_lower_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_1m_lower_sysperiod ON public.soundings_vnsl_1m USING btree (lower(sys_period));


--
-- Name: soundings_vnsl_1m_metadata_id; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_1m_metadata_id ON public.soundings_vnsl_1m USING btree (metadata_id);


--
-- Name: soundings_vnsl_1m_raster; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_1m_raster ON public.soundings_vnsl_1m USING gist (public.st_convexhull(rast));


--
-- Name: soundings_vnsl_1m_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_1m_sysperiod ON public.soundings_vnsl_1m USING gist (sys_period);


--
-- Name: soundings_vnsl_1m_tile_extent_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_1m_tile_extent_idx ON public.soundings_vnsl_1m USING gist (tile_extent);


--
-- Name: soundings_vnsl_1m_tile_geom_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_1m_tile_geom_idx ON public.soundings_vnsl_1m USING gist (tile_geom);


--
-- Name: soundings_vnsl_25cm_lower_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_25cm_lower_sysperiod ON public.soundings_vnsl_25cm USING btree (lower(sys_period));


--
-- Name: soundings_vnsl_25cm_metadata_id; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_25cm_metadata_id ON public.soundings_vnsl_25cm USING btree (metadata_id);


--
-- Name: soundings_vnsl_25cm_raster; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_25cm_raster ON public.soundings_vnsl_25cm USING gist (public.st_convexhull(rast));


--
-- Name: soundings_vnsl_25cm_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_25cm_sysperiod ON public.soundings_vnsl_25cm USING gist (sys_period);


--
-- Name: soundings_vnsl_25cm_tile_extent_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_25cm_tile_extent_idx ON public.soundings_vnsl_25cm USING gist (tile_extent);


--
-- Name: soundings_vnsl_25cm_tile_geom_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_25cm_tile_geom_idx ON public.soundings_vnsl_25cm USING gist (tile_geom);


--
-- Name: soundings_vnsl_4m_lower_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_4m_lower_sysperiod ON public.soundings_vnsl_4m USING btree (lower(sys_period));


--
-- Name: soundings_vnsl_4m_metadata_id; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_4m_metadata_id ON public.soundings_vnsl_4m USING btree (metadata_id);


--
-- Name: soundings_vnsl_4m_raster; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_4m_raster ON public.soundings_vnsl_4m USING gist (public.st_convexhull(rast));


--
-- Name: soundings_vnsl_4m_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_4m_sysperiod ON public.soundings_vnsl_4m USING gist (sys_period);


--
-- Name: soundings_vnsl_4m_tile_extent_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_4m_tile_extent_idx ON public.soundings_vnsl_4m USING gist (tile_extent);


--
-- Name: soundings_vnsl_4m_tile_geom_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_4m_tile_geom_idx ON public.soundings_vnsl_4m USING gist (tile_geom);


--
-- Name: soundings_vnsl_50cm_lower_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_50cm_lower_sysperiod ON public.soundings_vnsl_50cm USING btree (lower(sys_period));


--
-- Name: soundings_vnsl_50cm_metadata_id; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_50cm_metadata_id ON public.soundings_vnsl_50cm USING btree (metadata_id);


--
-- Name: soundings_vnsl_50cm_raster; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_50cm_raster ON public.soundings_vnsl_50cm USING gist (public.st_convexhull(rast));


--
-- Name: soundings_vnsl_50cm_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_50cm_sysperiod ON public.soundings_vnsl_50cm USING gist (sys_period);


--
-- Name: soundings_vnsl_50cm_tile_extent_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_50cm_tile_extent_idx ON public.soundings_vnsl_50cm USING gist (tile_extent);


--
-- Name: soundings_vnsl_50cm_tile_geom_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_50cm_tile_geom_idx ON public.soundings_vnsl_50cm USING gist (tile_geom);


--
-- Name: soundings_vnsl_8m_lower_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_8m_lower_sysperiod ON public.soundings_vnsl_8m USING btree (lower(sys_period));


--
-- Name: soundings_vnsl_8m_metadata_id; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_8m_metadata_id ON public.soundings_vnsl_8m USING btree (metadata_id);


--
-- Name: soundings_vnsl_8m_raster; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_8m_raster ON public.soundings_vnsl_8m USING gist (public.st_convexhull(rast));


--
-- Name: soundings_vnsl_8m_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_8m_sysperiod ON public.soundings_vnsl_8m USING gist (sys_period);


--
-- Name: soundings_vnsl_8m_tile_extent_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_8m_tile_extent_idx ON public.soundings_vnsl_8m USING gist (tile_extent);


--
-- Name: soundings_vnsl_8m_tile_geom_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_vnsl_8m_tile_geom_idx ON public.soundings_vnsl_8m USING gist (tile_geom);


--
-- Name: soundings_western_16m_lower_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_western_16m_lower_sysperiod ON public.soundings_western_16m USING btree (lower(sys_period));


--
-- Name: soundings_western_16m_metadata_id; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_western_16m_metadata_id ON public.soundings_western_16m USING btree (metadata_id);


--
-- Name: soundings_western_16m_raster; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_western_16m_raster ON public.soundings_western_16m USING gist (public.st_convexhull(rast));


--
-- Name: soundings_western_16m_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_western_16m_sysperiod ON public.soundings_western_16m USING gist (sys_period);


--
-- Name: soundings_western_16m_tile_extent_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_western_16m_tile_extent_idx ON public.soundings_western_16m USING gist (tile_extent);


--
-- Name: soundings_western_16m_tile_geom_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_western_16m_tile_geom_idx ON public.soundings_western_16m USING gist (tile_geom);


--
-- Name: soundings_western_1m_lower_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_western_1m_lower_sysperiod ON public.soundings_western_1m USING btree (lower(sys_period));


--
-- Name: soundings_western_1m_metadata_id; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_western_1m_metadata_id ON public.soundings_western_1m USING btree (metadata_id);


--
-- Name: soundings_western_1m_raster; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_western_1m_raster ON public.soundings_western_1m USING gist (public.st_convexhull(rast));


--
-- Name: soundings_western_1m_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_western_1m_sysperiod ON public.soundings_western_1m USING gist (sys_period);


--
-- Name: soundings_western_1m_tile_extent_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_western_1m_tile_extent_idx ON public.soundings_western_1m USING gist (tile_extent);


--
-- Name: soundings_western_1m_tile_geom_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_western_1m_tile_geom_idx ON public.soundings_western_1m USING gist (tile_geom);


--
-- Name: soundings_western_25cm_lower_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_western_25cm_lower_sysperiod ON public.soundings_western_25cm USING btree (lower(sys_period));


--
-- Name: soundings_western_25cm_metadata_id; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_western_25cm_metadata_id ON public.soundings_western_25cm USING btree (metadata_id);


--
-- Name: soundings_western_25cm_raster; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_western_25cm_raster ON public.soundings_western_25cm USING gist (public.st_convexhull(rast));


--
-- Name: soundings_western_25cm_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_western_25cm_sysperiod ON public.soundings_western_25cm USING gist (sys_period);


--
-- Name: soundings_western_25cm_tile_extent_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_western_25cm_tile_extent_idx ON public.soundings_western_25cm USING gist (tile_extent);


--
-- Name: soundings_western_25cm_tile_geom_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_western_25cm_tile_geom_idx ON public.soundings_western_25cm USING gist (tile_geom);


--
-- Name: soundings_western_4m_lower_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_western_4m_lower_sysperiod ON public.soundings_western_4m USING btree (lower(sys_period));


--
-- Name: soundings_western_4m_metadata_id; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_western_4m_metadata_id ON public.soundings_western_4m USING btree (metadata_id);


--
-- Name: soundings_western_4m_raster; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_western_4m_raster ON public.soundings_western_4m USING gist (public.st_convexhull(rast));


--
-- Name: soundings_western_4m_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_western_4m_sysperiod ON public.soundings_western_4m USING gist (sys_period);


--
-- Name: soundings_western_4m_tile_extent_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_western_4m_tile_extent_idx ON public.soundings_western_4m USING gist (tile_extent);


--
-- Name: soundings_western_4m_tile_geom_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_western_4m_tile_geom_idx ON public.soundings_western_4m USING gist (tile_geom);


--
-- Name: soundings_western_50cm_lower_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_western_50cm_lower_sysperiod ON public.soundings_western_50cm USING btree (lower(sys_period));


--
-- Name: soundings_western_50cm_metadata_id; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_western_50cm_metadata_id ON public.soundings_western_50cm USING btree (metadata_id);


--
-- Name: soundings_western_50cm_raster; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_western_50cm_raster ON public.soundings_western_50cm USING gist (public.st_convexhull(rast));


--
-- Name: soundings_western_50cm_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_western_50cm_sysperiod ON public.soundings_western_50cm USING gist (sys_period);


--
-- Name: soundings_western_50cm_tile_extent_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_western_50cm_tile_extent_idx ON public.soundings_western_50cm USING gist (tile_extent);


--
-- Name: soundings_western_50cm_tile_geom_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_western_50cm_tile_geom_idx ON public.soundings_western_50cm USING gist (tile_geom);


--
-- Name: soundings_western_8m_lower_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_western_8m_lower_sysperiod ON public.soundings_western_8m USING btree (lower(sys_period));


--
-- Name: soundings_western_8m_metadata_id; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_western_8m_metadata_id ON public.soundings_western_8m USING btree (metadata_id);


--
-- Name: soundings_western_8m_raster; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_western_8m_raster ON public.soundings_western_8m USING gist (public.st_convexhull(rast));


--
-- Name: soundings_western_8m_sysperiod; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_western_8m_sysperiod ON public.soundings_western_8m USING gist (sys_period);


--
-- Name: soundings_western_8m_tile_extent_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_western_8m_tile_extent_idx ON public.soundings_western_8m USING gist (tile_extent);


--
-- Name: soundings_western_8m_tile_geom_idx; Type: INDEX; Schema: public; Owner: pgrastertime
--

CREATE INDEX soundings_western_8m_tile_geom_idx ON public.soundings_western_8m USING gist (tile_geom);


--
-- PostgreSQL database dump complete
--

