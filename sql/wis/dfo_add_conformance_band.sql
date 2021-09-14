-- FUNCTION: public.dfo_add_conformance_band(text, text, text, numeric, text, text)

-- DROP FUNCTION public.dfo_add_conformance_band(text, text, text, numeric, text, text);

CREATE OR REPLACE FUNCTION public.dfo_add_conformance_band(
	rastertable text,
	sectortable text,
	sectorgeom text,
	resolution numeric,
	filename text,
	schema_ text DEFAULT 'public'::text)
    RETURNS text
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE
	sounding record;
    sounding_for_id record;
    num_intersection_sectors integer;
	strsql text;
	rastcol text;
BEGIN
	strsql := concat('SELECT r_raster_column FROM raster_columns WHERE r_table_name =',quote_literal(rastertable),
					  ' AND r_table_schema=', quote_literal(schema_));
	--RAISE notice 'sql = %', strsql;
	
	EXECUTE strsql INTO rastcol;
	
	--raise notice 'raster column name : %', rastcol;
	
	--RAISE LOG 'The DFO_ADD_CONFORMANCE_BAND() is called';
	strsql := 'SELECT * FROM ' || schema_ ||'.' || rastertable ||' WHERE filename LIKE ' || quote_literal(filename||'%') || ' AND resolution = ' || resolution;
	--RAISE LOG 'the sql is:   %', strsql;
	FOR sounding IN EXECUTE strsql
	LOOP
		
		--RAISE notice 'id = %', sounding.id;
	
		--RAISE LOG ' The input parameters are :   %       and      %', rastertable, filename;
		-- if there is no intersection between the raster and any of the sectors, we continue with the loop
	
		strsql := ' SELECT COUNT(dg.id) FROM wis.' || sectortable || ' dg, ' || schema_ ||'.' || rastertable ||
		' rt where rt.id = '|| sounding.id  || ' AND ST_intersects(tile_geom, geom_3979 )';
		--RAISE LOG 'strsql = %', strsql;

		EXECUTE strsql
		INTO num_intersection_sectors;
	
		--RAISE NOTICE 'numer of intersections with sectors:     % ', num_intersection_sectors;
	
	
		IF num_intersection_sectors = 0 THEN
		
			strsql := 'UPDATE '|| schema_ ||'.' || rastertable ||'  SET ' || rastcol || '   =  ST_AddBand(ST_Band(' || rastcol || ' , ''{1,2,3}''::int[]), ' ||
			'ST_AsRaster( ST_Envelope(' || rastcol || '), ' || rastcol || ', ''32BF'', 3.40282346638529e+38, 3.40282346638529e+38 ) , 1, 4) WHERE id = ' ||sounding.id;
			--RAISE LOG 'strsql when there is no intersection = %', strsql;
			EXECUTE strsql;
			CONTINUE;

		END IF;
		
		
		----    if the tile has intersection with at least one sector then: 
		DROP TABLE IF EXISTS table_for_doing_st_union_onsounding_and_conformance_1745;
		strsql := 'CREATE TEMPORARY TABLE table_for_doing_st_union_onsounding_and_conformance_1745 AS( select ST_Union(ST_MapAlgebra(ST_Clip('||
		 rastcol || ' , 1, geom_3979, 3.40282346638529e+38, FALSE ), 1 , ''32BF'' , quote_literal(maintained) , 3.40282346638529e+38) ) rast FROM '||
		schema_ ||'.' || rastertable || ' rt, ' ||' wis.' || sectortable || ' WHERE rt.id = '|| sounding.id ||
		' AND ST_intersects(' || rastcol || ', geom_3979 ))';
		--RAISE LOG 'strsql:     % ', strsql;
		EXECUTE strsql;

		
		-- inserting the clipped version of the original raster into the temp table to do ST_Union
		-- at the end
		-- band 1 is used which is minimum depth
		strsql := 'INSERT INTO table_for_doing_st_union_onsounding_and_conformance_1745 SELECT ST_Union(ST_Clip(' || rastcol || ', 1, geom_3979, 3.40282346638529e+38, FALSE ))'
		|| ' FROM wis.' || sectortable || ' , ' || schema_ ||'.' || rastertable || ' rt WHERE rt.id = ' || sounding.id 
		|| ' AND ST_intersects(' || rastcol || ', geom_3979 )' ;
		--RAISE LOG 'strsql:     % ', strsql;
		EXECUTE strsql;
		
		
		-- Doing the calculation for conformance
		DROP TABLE IF EXISTS table_for_doing_st_union_onsounding_and_conformance_1745_union;
		CREATE TEMPORARY TABLE table_for_doing_st_union_onsounding_and_conformance_1745_union
		AS(
		SELECT ST_Union(rast, 'SUM') rast from table_for_doing_st_union_onsounding_and_conformance_1745
 		);
		
		
		-- updating the rastertable table
		strsql := 'UPDATE ' || schema_ || '.' || rastertable || ' rt SET ' || rastcol || ' =  ST_AddBand(ST_Band(rt.' || rastcol || ', ''{1,2,3}''::int[]), tmp.rast, 1, 4)  '
		|| 'FROM table_for_doing_st_union_onsounding_and_conformance_1745_union tmp WHERE id = '  || sounding.id;
		--RAISE LOG 'strsql:     % ', strsql;
		EXECUTE strsql;

		
    END LOOP;

    RETURN 'Run successfully';
	
    EXCEPTION WHEN OTHERS THEN
	    RAISE EXCEPTION' % ', SQLERRM;
		RAISE LOG 'an exception happened while running this file %', SQLERRM ;

END;
$BODY$;

