-- FUNCTION: public.dfo_metadata(text, text)

-- DROP FUNCTION public.dfo_metadata(text, text);

CREATE OR REPLACE FUNCTION public.dfo_metadata(
	rastertable text,
	filename text)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$

	DECLARE
	  strsql text;
	BEGIN


	--Set metadata_id hack necessaire car le xml n'est pas gérer dans le code python. 
	-- on va chercher le objnam dans la table metadata qui n'a pas encore été affeté et on l'affecte au enregistrements en traitement.

 	strsql = concat('UPDATE ',rastertable, ' set metadata_id = (
				   	select objnam from ',rastertable,' RIGHT JOIN ',rastertable,'_metadata ON metadata_id=objnam
					where metadata_id is null
				   )
					WHERE filename LIKE ',quote_literal(filename||'%'));
	raise debug 'Update metadata_id: % ', strsql;
	EXECUTE strsql;

	--Set the tile sys_period from metadata
	strsql = concat('UPDATE ',rastertable,'
					SET sys_period = tstzrange( sursta::timestamp with time zone, null )
					FROM  ',rastertable,'_metadata   WHERE  objnam  = metadata_id
					AND filename LIKE ',quote_literal(filename||'%'));

	raise debug 'Update sys_period:  % ', strsql;				
	EXECUTE strsql;	

  exception when others then

      raise notice ' % ', SQLERRM;

END;

$BODY$;
