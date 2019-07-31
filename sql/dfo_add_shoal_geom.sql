CREATE OR REPLACE FUNCTION public.dfo_add_shoal_geom(
	rastertable text,
	resolution numeric,
	shoal_limit numeric,
	filename text)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$

	DECLARE
      state text;
	  strsql text;
	  rastcol text;
	BEGIN
--Shoal 
	SELECT r_raster_column FROM raster_columns WHERE r_table_name = rastertable INTO rastcol;

drop  table if exists shoal_tmp;
strsql = concat( 'create temporary table shoal_tmp
as
select
id, ST_Reclass(st_band(',rastcol,',5), 1, ''-20-',shoal_limit,'):''|| ST_BandNoDataValue( ',rastcol,',1)||'', [',shoal_limit,'-15:1'', ''4BUI'',ST_BandNoDataValue( ',rastcol,',1)  )
from ',rastertable,' 
where filename like ', quote_literal(filename||'%depth%'),'
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
