-- FUNCTION: public.dfo_update_soundings_tables(text)

-- DROP FUNCTION public.dfo_update_soundings_tables(text);

CREATE OR REPLACE FUNCTION public.dfo_update_soundings_tables(
	rastertable text)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$

DECLARE
	query TEXT;
	sounding RECORD;
	n integer;
	 resol text  ;
	 q text[];
	 
BEGIN
q:= array['16m','8m','4m','2m','1m','50cm','25cm'];
 query := concat( 'SELECT distinct objnam FROM ', rastertable,'_metadata') ;
 FOR sounding IN EXECUTE query  
        LOOP
      RAISE NOTICE '%', sounding.objnam;
 	SELECT count(1) 
	FROM soundings_8m 
	WHERE metadata_id = sounding.objnam
	INTO n;
 
	IF n>1  THEN
	RAISE NOTICE 'DELETE FROM DIFFUSION FIST';
	
		FOREACH resol  IN ARRAY q LOOP --'{'16m','8m','4m','2m','1m','50cm','25cm'}' LOOP
			query := concat( 'DELETE FROM soundings_',resol,' 
							WHERE metadata_id = ', quote_literal(sounding.objnam));
			execute query;

		 
		END LOOP  ;
		--Delete old metadata
		DELETE FROM metadata WHERE objnam =  sounding.objnam;
		
	END IF;
	
	RAISE NOTICE 'CAN INSERT INTO DIFFUSION';
	 
	--Insert into partition "production" table
	query := concat ('INSERT INTO soundings(tile_id,rast,resolution,filename,sys_period,tile_extent,tile_geom,metadata_id,shoal_geom)
					SELECT tile_id,raster,resolution,filename,sys_period,tile_extent,tile_geom,metadata_id,shoal_geom
					FROM ',rastertable,' WHERE metadata_id = ', quote_literal(sounding.objnam));
				 
	execute query;
	
	DELETE FROM metadata WHERE objnam =  sounding.objnam;
	--insert into  metadata 
	query := concat('INSERT INTO metadata (dunits, hordat, hunits, objnam, surath, surend, sursta, surtyp, tecsou, verdat, ch_typ, client, cretim, glocat, hcosys, idprnt, km_end, kmstar, lwschm, modtim, planam, plocat, prjtyp, srcfil, srfcat, srfdsc, srfres, srftyp, sursso, uidcre)
	SELECT dunits, hordat, hunits, objnam, surath, surend, sursta, surtyp, tecsou, verdat, ch_typ, client, cretim, glocat, hcosys, idprnt, km_end, kmstar, lwschm, modtim, planam, plocat, prjtyp, srcfil, srfcat, srfdsc, srfres, srftyp, sursso, uidcre
	FROM ',rastertable,'_metadata' ,' WHERE objnam = ', quote_literal(sounding.objnam));
	 
	execute query;
 END LOOP;
           
		   

  
exception when others then
	raise exception ' % ', SQLERRM;

END;

$BODY$;


