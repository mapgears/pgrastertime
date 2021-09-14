-- FUNCTION: public.dfo_update_most_recent_tables_v2(text, text)

-- DROP FUNCTION public.dfo_update_most_recent_tables_v2(text, text);

CREATE OR REPLACE FUNCTION public.dfo_update_most_recent_tables_v2(
	schema_ text,
	rastertable text)
    RETURNS text
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$DECLARE
	strsql TEXT;
	sounding RECORD;
	resol text;
	resolArray text[];
	grid text;
	intresol integer;
    msg text;
BEGIN

    -- Loop throught all resolutions
    resolArray:= ARRAY['16m','8m','4m','2m','1m','50cm','25cm'];
    intresol = 0;
    FOREACH resol  IN ARRAY resolArray LOOP
        intresol =  trim (trailing 'c' from (trim(trailing 'm' from resol )));
		
        IF resol  IN ( '16m' ) THEN 
            grid = '16m';
        ELSIF resol IN ('8m') THEN 
            grid = '8m';
        ELSE  
            grid = '4m';
        END IF; 
        msg := 'Next resolution to be processed: ' || intresol || ' / with grid : ' || grid;
		RAISE NOTICE '%', msg;

        strsql := concat( 'SELECT array_to_string(array_agg(distinct  g.id),'','') AS id FROM ', rastertable ,' l JOIN wis.grid_',grid,' g     
				   ON st_intersects(l.tile_extent,g.tile_extent ) WHERE resolution = ',intresol,'') ;
				  
		RAISE NOTICE '%', strsql;
 
        FOR sounding IN EXECUTE strsql
        LOOP
 
 	        IF sounding.id IS NOT NULL THEN

	            strsql = concat( 'DELETE from ', schema_, '.most_recent_',resol,' WHERE id IN (	 
					 	      SELECT distinct(a.id) 
					 	      FROM ', schema_, '.most_recent_',resol,' a JOIN ',rastertable,' b 
					 	      ON st_intersects(a.tile_extent, b.tile_extent) 
							  WHERE b.resolution = ',intresol,' AND a.id IN (',sounding.id,'))');
							  --WHERE b.resolution = ',intresol,')');
					 	      
 
                RAISE DEBUG 'Delete most_recent_n with %' , strsql;
                EXECUTE strsql;
 
                strsql = concat ('INSERT INTO ', schema_, '.most_recent_',resol,' WITH dataset AS ( 
                                SELECT ST_Union(s.rast ORDER BY lower(sys_period)) rast, g.tile_extent as geom,g.id FROM ', schema_, '.soundings_',resol,' s  
                                JOIN wis.grid_',grid,'  g ON ST_Intersects(tile_geom , g.tile_extent) and sys_period=''3000-01-01''
                                AND g.id in (',sounding.id,') GROUP BY g.tile_extent,g.id)  
                                SELECT ST_Clip (rast,st_transform(geom,st_srid(rast)) ) rast, id, geom FROM dataset');
 
                RAISE DEBUG 'Insert into most_recent_n with %', strsql;
                EXECUTE strsql;
				
            END IF;
	    END LOOP;
    END LOOP;

    RETURN 'Update most_recent_n tables...';
	
    EXCEPTION WHEN OTHERS THEN
	    RAISE EXCEPTION' % ', SQLERRM;

END;
$BODY$;

