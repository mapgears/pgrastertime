-- All other tables and trigger  needs in WIS data model
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

-- Soudings template table used for all regions and resolutions
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

-- pgrastertime insert into error table when it fail

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

-- The metadata table need in WIS database

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
