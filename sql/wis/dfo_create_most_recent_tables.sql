-- FUNCTION: public.dfo_create_most_recent_tables(text, text, text)

-- DROP FUNCTION public.dfo_create_most_recent_tables(text, text, text);

CREATE OR REPLACE FUNCTION public.dfo_create_most_recent_tables(
	schema_ text,
	rastertable text,
	resol text)
    RETURNS text
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$

DECLARE
	strsql TEXT;
	sounding RECORD;
	resolArray text[];
	grid text;
	intresol integer;
	nbrow integer;
    msg text;
BEGIN
			   
    --Create table first
	 strsql := concat( 'DROP TABLE IF EXISTS ', schema_, '.most_recent_',resol ,';',
	                   'CREATE TABLE ', schema_, '.most_recent_',resol ,'(rast raster,id integer,tile_extent geometry(Polygon,3979));');
	RAISE DEBUG '%', strsql;
	EXECUTE strsql;
    
	-- We need the resolution id to query soundings table (16, 8, 4, 2, 1 m and 50, 25 cm)
	intresol =  trim (trailing 'c' from (trim(trailing 'm' from resol )));
	
    -- match grid resolution to merge tile_extent
    IF resol  IN ( '16m','8m','4m','2m' ) THEN 
       grid = '16m';
    ELSIF resol IN ('1m') THEN 
       grid = '8m';
    ELSE  
       grid = '4m';
    END IF; 
					  
    msg := concat('Integer resolution: ' , intresol , ' / Grid : ' , grid);
	RAISE NOTICE '%', msg;

    strsql := concat( 'SELECT array_to_string(array_agg(distinct  g.id),'','') AS id FROM ', schema_, '.', rastertable ,' l JOIN wis.grid_', grid,' g     
				   ON st_intersects(l.tile_extent,g.tile_extent ) WHERE resolution = ',intresol,'') ;
    -- RAISE DEBUG '%', strsql;
    FOR sounding IN EXECUTE strsql
    LOOP
 
 	    IF sounding.id IS NOT NULL THEN
 
                strsql = concat ('INSERT INTO ', schema_, '.most_recent_',resol,' WITH dataset AS ( 
                                SELECT ST_Union(s.rast ORDER BY lower(sys_period)) rast, g.tile_extent as geom,g.id FROM ',rastertable,' s  
                                JOIN wis.grid_',grid,'  g ON ST_Intersects(tile_geom , g.tile_extent) and sys_period=''3000-01-01''
                                AND g.id in (',sounding.id,') GROUP BY g.tile_extent,g.id)  
                                SELECT ST_Clip (rast,st_transform(geom,st_srid(rast)) ) rast, id, geom FROM dataset');
                --msg := concat('Insert into wis.most_recent_',resol,' table ...');
                RAISE DEBUG '%', concat('Insert into ', schema_, '.most_recent_',resol,' table ...');
                EXECUTE strsql;
				
        END IF;
    END LOOP;
	
    EXECUTE concat('SELECT count(*) FROM ', schema_, '.most_recent_',resol) INTO nbrow;
    RETURN concat('Create ', schema_, '.most_recent_',resol,' tables, and added ',nbrow,' rows into it.');
	
    EXCEPTION WHEN OTHERS THEN
	    RAISE EXCEPTION' % ', SQLERRM;

END;
$BODY$;

ALTER FUNCTION public.dfo_create_most_recent_tables(text, text, text)
    OWNER TO pgrastertime;
