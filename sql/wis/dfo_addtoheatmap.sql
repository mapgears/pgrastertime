-- FUNCTION: public.dfo_addtoheatmap(integer[], integer[], integer)

DROP FUNCTION public.dfo_addtoheatmap(integer[], integer[], integer);

CREATE OR REPLACE FUNCTION public.dfo_addtoheatmap(
	_coordx integer[],
	_coordy integer[],
	_id integer)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$

	DECLARE
      
	BEGIN
	 
	 FOR i IN 1 .. array_upper(_coordX, 1)
LOOP

update river_test set rast = 
  st_setvalue ( st_band(rast,1),_coordX[i],_coordY[i] ,st_value(st_band(rast,1),_coordX[i],_coordY[i])+1) 
  where id =_id;

  -- RAISE NOTICE '%', _id||':' || _coordX[i]||':' || _coordY[i];      -- single quotes!
END LOOP;
	 
  exception when others then

      raise notice ' % ', SQLERRM;

END;

$BODY$;
