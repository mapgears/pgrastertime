
--Création d'un opérateur = pour les tstz range
CREATE OR REPLACE FUNCTION tstz_equals (
tstzrange, text )
RETURNS boolean AS '
select $1 @> $2::timestamp with time zone ;
' LANGUAGE sql IMMUTABLE;

DROP OPERATOR IF EXISTS = (tstzrange, text);

CREATE OPERATOR = (
LEFTARG = tstzrange,
RIGHTARG = TEXT,
PROCEDURE = tstz_equals
);

CREATE OR REPLACE FUNCTION public.st_clip(
	rast raster,
	nband integer[],
	geom geometry,
	nodataval double precision[] DEFAULT NULL::double precision[],
	crop boolean DEFAULT true)
    RETURNS raster
    LANGUAGE 'plpgsql'

    COST 100
    IMMUTABLE PARALLEL SAFE
AS $BODY$
	BEGIN
		-- wrong version																							 
		-- short-cut if geometry's extent fully contains raster's extent
		-- IF (nodataval IS NULL OR array_length(nodataval, 1) < 1) AND geom ~ ST_Envelope(rast) 
		-- corrected version (bug-fix)
		-- no more short-cut!!!  if geometry's extent fully contains raster's extent  
		IF (nodataval IS NULL OR array_length(nodataval, 1) < 1) AND st_contains(geom, ST_Envelope(rast))
			THEN RETURN rast;
		END IF;

		RETURN public._ST_Clip($1, $2, $3, $4, $5);
	END;
	$BODY$;
