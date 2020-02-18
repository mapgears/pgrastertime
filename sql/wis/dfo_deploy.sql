-- FUNCTION: public.dfo_deploy(text)

DROP FUNCTION public.dfo_deploy(text);

CREATE OR REPLACE FUNCTION public.dfo_deploy(
	rastertable text)
RETURNS text
LANGUAGE 'plpgsql'
COST 100
VOLATILE 
AS $BODY$

DECLARE
    query_ TEXT;
    sounding RECORD;
    n integer;
    resol text  ;
    q text[];
	i integer;
BEGIN
    i :=0;
    q := array['16m','8m','4m','2m','1m','50cm','25cm'];
    query_ := concat( 'SELECT distinct objnam FROM ', rastertable,'_metadata') ;
    FOR sounding IN EXECUTE query_  
    LOOP
        RAISE NOTICE 'objnam = %', sounding.objnam;
		i = i + 1;
 	    SELECT count(1) FROM  soundings_8m WHERE metadata_id = sounding.objnam INTO n;

	    IF n>1  THEN
	        RAISE NOTICE 'Already deploy, deleting first';
	
		    FOREACH resol IN ARRAY q LOOP --'{'16m','8m','4m','2m','1m','50cm','25cm'}' LOOP
			    query_ := concat( 'DELETE FROM soundings_',resol,' 
							WHERE metadata_id = ', quote_literal(sounding.objnam));
			    EXECUTE query_; 
		    END LOOP;
		
		--Delete old metadata
		DELETE FROM  metadata WHERE objnam=sounding.objnam;
		
	    END IF;
	
	    RAISE NOTICE 'Insert into deploy table (soundings_[n])';
	 
	    --Insert into partition "production" table
	    query_ := concat ('INSERT INTO soundings(tile_id,rast,resolution,filename,sys_period,tile_extent,tile_geom,metadata_id,shoal_geom)
					SELECT tile_id,raster,resolution,filename,sys_period,tile_extent,tile_geom,metadata_id,shoal_geom
					FROM ',rastertable,' WHERE metadata_id = ', quote_literal(sounding.objnam));
				 
	    EXECUTE query_;
	
	    RAISE NOTICE 'Insert into deploy matadata table';
	    DELETE FROM metadata WHERE objnam =  sounding.objnam;
	    --insert into  metadata 
	    query_ := concat('INSERT INTO metadata (dunits, hordat, hunits, objnam, surath, surend, sursta, surtyp, tecsou, verdat, ch_typ, client, cretim, glocat, hcosys, idprnt, km_end, kmstar, lwschm, modtim, planam, plocat, prjtyp, srcfil, srfcat, srfdsc, srfres, srftyp, sursso, uidcre)
	                   SELECT dunits, hordat, hunits, objnam, surath, surend, sursta, surtyp, tecsou, verdat, ch_typ, client, cretim, glocat, hcosys, idprnt, km_end, kmstar, lwschm, modtim, planam, plocat, prjtyp, srcfil, srfcat, srfdsc, srfres, srftyp, sursso, uidcre
	                   FROM ',rastertable,'_metadata' ,' WHERE objnam = ', quote_literal(sounding.objnam));
	 
	    EXECUTE query_;
	
    END LOOP;
       
    RETURN 'Deploy '|| i ||' objname files';
	
    EXCEPTION WHEN OTHERS THEN
	    RAISE EXCEPTION' % ', SQLERRM;

END;
$BODY$;
