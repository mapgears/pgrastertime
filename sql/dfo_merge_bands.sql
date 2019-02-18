-- FUNCTION: public.dfo_merge_bands(text)

-- DROP FUNCTION public.dfo_merge_bands(text);

CREATE OR REPLACE FUNCTION public.dfo_merge_bands(
	rastertable text)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$

	DECLARE
      rastcol text;
	  strsql text;
	  rastTypes text[] = array['mean','stddev','density'];
	  rastType text;
	BEGIN
	--Merging all bands to the "depth" tiles
	SELECT r_raster_column FROM raster_columns WHERE r_table_name = rastertable INTO rastcol; 
     
    FOREACH rastType IN ARRAY rastTypes
	LOOP
     
		--Add 'rastType' band to his corresponding depth tile 
		strsql = concat('UPDATE ',rastertable,' u SET ',rastcol,' = bnd from 
						(SELECT d.id, (ST_AddBand(d.',rastcol,' , o.',rastcol,' ,1)) as bnd
						 FROM ',rastertable,' d join  ',rastertable,' o ON
								ST_Equals(d.tile_extent,o.tile_extent) 
								AND d.filename LIKE ''%depth.tiff''  
								AND o.filename  LIKE ''%',rastType,'.tiff'' 
								AND o.resolution=d.resolution) sr
						 WHERE sr.id=u.id');
    	raise notice '%  ',strsql;
		EXECUTE strsql;
	END LOOP;

  exception when others then

      raise notice ' % ', SQLERRM;

END;

$BODY$;
 