-- FUNCTION: public.dfo_add_conformance_band(text, text, text, integer)

-- DROP FUNCTION public.dfo_add_conformance_band(text, text, text, integer);

CREATE OR REPLACE FUNCTION public.dfo_add_conformance_band(
	rastertable text,
	sectortable text,
	sectorgeom text,
	resolution integer)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$

DECLARE
	state text;
	nbands integer;
	rastcol text;
	strsql text;
BEGIN

	SELECT r_raster_column FROM raster_columns WHERE r_table_name = rastertable INTO rastcol;
	
	 
  --Adding a band to manage de 'state of the channel'
  strsql = concat ('UPDATE ',rasterTable,'
                  SET ',rastcol,' = ST_AddBand(',rastcol,', --destination raster.
                                        ST_BandPixelType(',rastcol,',1), --pixel type
                                        ST_BandNoDataValue(',rastcol,',1), -- assign nodata value to all pixels
                                        ST_BandNoDataValue(',rastcol,',1)) -- assign nodata value to raster 
				  WHERE filename like ''%depth%''
				  AND resolution = ''',resolution,'''');
  raise notice 'Add Band: %', strsql;			  
 
  EXECUTE strsql;
  raise notice ' % ',' band added to raster';
  
  --Intersecting 'niveau maintenu' with raster to give a 'conformance' value to pixels
  strsql =concat ('UPDATE ',rasterTable,' upd
                  SET ',rastcol,' = ST_SetValues( ',rastcol,',
                                          5 ,
                                           geomval_arr)
                  FROM
                  (SELECT array_agg (geomval) geomval_arr,id
                   FROM ( SELECT intrsct.id,
                                 ((intrsct.geomval).geom, niveau_maintenu +(intrsct.geomval).val)::geomval  as geomval
                  		    FROM ( SELECT A.id,
                                        s.niveau_maintenu,
                                        ST_Intersection(A.',rastcol,', s.',sectorgeom,') As geomval
                                 FROM ',rasterTable,' AS A
                                 JOIN ',sectorTable,' s ON st_intersects(tile_geom ,',sectorgeom,')
                  			     WHERE filename like ''%depth%''
										AND resolution = ''',resolution,''') AS intrsct
                  	     )sr GROUP BY id
                  ) frm
                  WHERE frm.id=upd.id');
	raise notice 'Update Band: %', strsql;			  
	EXECUTE strsql;
	raise notice ' % ',' band updated';
  exception when others then

      raise notice 'ERREUR:  %', SQLERRM;

END;

$BODY$;
