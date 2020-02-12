-- FUNCTION: public.partition_insert_triggerv2()

-- DROP FUNCTION public.partition_insert_triggerv2();

CREATE FUNCTION public.partition_insert_triggerv2()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE 
t_region text;
BEGIN
	SELECT region FROM region_footprint  where st_intersects(new.tile_extent,geom) INTO t_region;
	
	--raise notice ' i: % : %', new.id, t_region ;
	
	IF t_region ='Atlantic' THEN 
		IF ( NEW.resolution = 0.25 ) THEN
			INSERT INTO soundings_atlantic_25cm VALUES (NEW.*);
		ELSIF ( NEW.resolution = 0.5 ) THEN
			INSERT INTO soundings_atlantic_50cm VALUES (NEW.*);
		ELSIF ( NEW.resolution = 1 ) THEN
			INSERT INTO soundings_atlantic_1m VALUES (NEW.*);
		ELSIF ( NEW.resolution = 2 ) THEN
			INSERT INTO soundings_atlantic_2m VALUES (NEW.*);
		ELSIF ( NEW.resolution = 4 ) THEN
			INSERT INTO soundings_atlantic_4m VALUES (NEW.*);
		ELSIF ( NEW.resolution = 8 ) THEN
			INSERT INTO soundings_atlantic_8m VALUES (NEW.*);
		ELSIF ( NEW.resolution = 16 ) THEN
			INSERT INTO soundings_atlantic_16m VALUES (NEW.*);
		END IF;
	
	ELSEIF t_region ='CA' THEN 
		IF ( NEW.resolution = 0.25 ) THEN
			INSERT INTO soundings_vnsl_25cm VALUES (NEW.*);
		ELSIF ( NEW.resolution = 0.5 ) THEN
			INSERT INTO soundings_vnsl_50cm VALUES (NEW.*);
		ELSIF ( NEW.resolution = 1 ) THEN
			INSERT INTO soundings_vnsl_1m VALUES (NEW.*);
		ELSIF ( NEW.resolution = 2 ) THEN
			INSERT INTO soundings_vnsl_2m VALUES (NEW.*);
		ELSIF ( NEW.resolution = 4 ) THEN
			INSERT INTO soundings_vnsl_4m VALUES (NEW.*);
		ELSIF ( NEW.resolution = 8 ) THEN
			INSERT INTO soundings_vnsl_8m VALUES (NEW.*);
		ELSIF ( NEW.resolution = 16 ) THEN
			INSERT INTO soundings_vnsl_16m VALUES (NEW.*);
		END IF;
	
	ELSEIF  t_region = 'Western' THEN 
		IF ( NEW.resolution = 0.25 ) THEN
			INSERT INTO soundings_western_25cm VALUES (NEW.*);
		ELSIF ( NEW.resolution = 0.5 ) THEN
			INSERT INTO soundings_western_50cm VALUES (NEW.*);
		ELSIF ( NEW.resolution = 1 ) THEN
			INSERT INTO soundings_western_1m VALUES (NEW.*);
		ELSIF ( NEW.resolution = 2 ) THEN
			INSERT INTO soundings_western_2m VALUES (NEW.*);
		ELSIF ( NEW.resolution = 4 ) THEN
			INSERT INTO soundings_western_4m VALUES (NEW.*);
		ELSIF ( NEW.resolution = 8 ) THEN
			INSERT INTO soundings_western_8m VALUES (NEW.*);
		ELSIF ( NEW.resolution = 16 ) THEN
			INSERT INTO soundings_western_16m VALUES (NEW.*);
		END IF;
	ELSE 
		INSERT INTO soundings_no_region VALUES (NEW.*);
	END IF;
	
	RETURN NULL;
 
	exception when others then
		INSERT INTO soundings_error VALUES (NEW.*);
		insert into soundings_error_reason values(new.id, sqlerrm );
		raise notice ' % ', SQLERRM;
		RETURN NULL;
END;
$BODY$;
