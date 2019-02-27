-- FUNCTION: public.dfo_add_shoal_geom(text, integer, numeric)

-- DROP FUNCTION public.dfo_add_shoal_geom(text, integer, numeric);

CREATE OR REPLACE FUNCTION public.dfo_add_shoal_geom(
	rastertable text,
	resolution integer,
	shoal_limit numeric)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$

	DECLARE
      state text;
	  strsql text;
	BEGIN
--Shoal 
drop  table if exists shoal_tmp;
strsql = concat( 'create temporary table shoal_tmp
as
select
id, ST_Reclass(st_band(raster,5), 1, ''-20-',shoal_limit,'):''|| ST_BandNoDataValue( raster,1)||'', [',shoal_limit,'-15:1'', ''4BUI'',ST_BandNoDataValue( raster,1)  )
from ',rastertable,' 
where filename like ''%_depth%''
and resolution =', resolution);

raise notice ' % ', strsql;

EXECUTE strsql;

EXECUTE format('update %s p 
			   		set shoal_geom = ST_Polygon(st_band(st_reclass,5))
				from shoal_tmp s
			    where p.id=s.id',rastertable);
				
  exception when others then

      raise notice ' % ', SQLERRM;

END;

$BODY$;
 