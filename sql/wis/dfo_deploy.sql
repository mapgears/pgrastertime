-- FUNCTION: public.dfo_deploy(text, text)

-- DROP FUNCTION public.dfo_deploy(text, text);

CREATE OR REPLACE FUNCTION public.dfo_deploy(
	shchema_ text,
	rastertable text)
    RETURNS text
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$

DECLARE
    obj TEXT;
	query_ text;
    sounding RECORD;
    n integer;
    resol text  ;
    q text[];
	i integer;
BEGIN
    i :=0;
    q := array['16m','8m','4m','2m','1m'];
    obj := concat( 'SELECT distinct objnam FROM ', rastertable,'_metadata') ;
    FOR sounding IN EXECUTE obj  
    LOOP
        RAISE NOTICE 'objnam = %', sounding.objnam;
		i = i + 1;
        --EXECUTE format('SELECT count(1) FROM %1$s.soundings_8m WHERE metadata_id = sounding.objnam', shchema_) INTO n;       
        query_ := concat( 'SELECT count(1) FROM ', shchema_ ,'.soundings_8m WHERE metadata_id =', quote_literal(sounding.objnam));
        RAISE NOTICE '%',query_;
		EXECUTE query_ INTO n;       
		
	    IF n>1  THEN
	        RAISE NOTICE 'Already deploy, deleting first';
	
		    FOREACH resol IN ARRAY q LOOP --'{'16m','8m','4m','2m','1m'}' LOOP
			    query_ := concat( 'DELETE FROM ', shchema_ , '.soundings_',resol,' WHERE metadata_id = ', quote_literal(sounding.objnam));
			    EXECUTE query_; 
		    END LOOP;
		
		   --Delete old metadata
		   query_ := concat( 'DELETE FROM ', shchema_ , '.metadata WHERE objnam = ', quote_literal(sounding.objnam));
		   EXECUTE query_; 
		
	    END IF;
	
	    RAISE NOTICE 'Insert into deploy table (soundings_[n])';
	 
	    --Insert into partition "production" table
	    query_ := concat ('INSERT INTO ', shchema_ ,'.soundings(tile_id,rast,resolution,filename,sys_period,tile_extent,tile_geom,metadata_id,shoal_geom)',
					       'SELECT tile_id,raster,resolution,filename,sys_period,tile_extent,tile_geom,metadata_id,shoal_geom FROM ',rastertable,' WHERE metadata_id = ', quote_literal(sounding.objnam));
		--RAISE NOTICE ' % ', query_;		 
	    EXECUTE query_;
	
	    RAISE NOTICE 'Insert into deploy matadata table';
	    query_ := concat('INSERT INTO ', shchema_ ,'.metadata (dunits, hordat, hunits, objnam, surath, surend, sursta, surtyp, tecsou, verdat, ch_typ, client, cretim, glocat, hcosys, idprnt, km_end, kmstar, lwschm, modtim, planam, plocat, prjtyp, srcfil, srfcat, srfdsc, srfres, srftyp, sursso, uidcre) ',
	                   'SELECT dunits, hordat, hunits, objnam, surath, surend, sursta, surtyp, tecsou, verdat, ch_typ, client, cretim, glocat, hcosys, idprnt, km_end, kmstar, lwschm, modtim, planam, plocat, prjtyp, srcfil, srfcat, srfdsc, srfres, srftyp, sursso, uidcre ',
	                   'FROM ',rastertable,'_metadata' ,' WHERE objnam = ', quote_literal(sounding.objnam));
	    --RAISE NOTICE ' % ', query_;	
	    EXECUTE query_;
	    i := i +1;
    END LOOP;
       
    RETURN 'Deploy '|| i ||' objnam files';
	
    EXCEPTION WHEN OTHERS THEN
	    RAISE EXCEPTION' % ', SQLERRM;

END;
$BODY$;
