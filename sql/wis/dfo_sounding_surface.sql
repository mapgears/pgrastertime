-- FUNCTION: public.dfo_sounding_surface(character varying, text)

-- DROP FUNCTION public.dfo_sounding_surface(character varying, text);

CREATE OR REPLACE FUNCTION public.dfo_sounding_surface(
	tablename character varying,
	metaid text)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE STRICT 
AS $BODY$
DECLARE
	query  text;
BEGIN
	
	if metaid  = 'all' then  --for all soundings in tablename
	    --create the geometry making union of all tile_geom for each soundings
		query:=concat('TRUNCATE  sounding_surface_s;
							INSERT INTO sounding_surface_s  
							 SELECT min(id) AS id,
								st_multi(st_union(tile_geom)) AS  geom,
								filename,
								lower(sys_period) as creatim,
								metadata_id
							  FROM ',tablename,'
							  GROUP BY  metadata_id ,filename,lower(sys_period);');	
							  
	else --for a give sounding
		--delete data for this sounding and recreate it.
		 
		query:=concat('DELETE FROM sounding_surface_s WHERE metadata_id = ',quote_literal(metaid),';  
						INSERT INTO sounding_surface_s  
						 SELECT min(id) AS id,
							st_multi(st_union(tile_geom)) AS  geom,
							filename,
							lower(sys_period) as creatim,
							metadata_id
						  FROM ',tablename,'
						  WHERE metadata_id = ',quote_literal(metaid),'
						  GROUP BY  metadata_id ,filename,lower(sys_period)');
						  
	END IF;
		
	raise notice '%', query;
	 
	EXECUTE query;

    
END;
$BODY$;

ALTER FUNCTION public.dfo_sounding_surface(character varying, text)
    OWNER TO stecyr;
