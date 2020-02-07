WITH 
  metadataid as (
	  SELECT distinct(metadata_id) as metadata_id FROM pgrastertime
  ),
  nb_deploy as (
SELECT SUM(cnt) as cnt FROM ( 
SELECT count(metadataid.metadata_id) as cnt FROM metadataid, soundings_16m s WHERE s.metadata_id = metadataid.metadata_id
union
SELECT count(metadataid.metadata_id) as cnt FROM metadataid, soundings_8m s WHERE s.metadata_id = metadataid.metadata_id
union
SELECT count(metadataid.metadata_id) as cnt FROM metadataid, soundings_4m s WHERE s.metadata_id = metadataid.metadata_id
union
SELECT count(metadataid.metadata_id) as cnt FROM metadataid, soundings_2m s WHERE s.metadata_id = metadataid.metadata_id
union
SELECT count(metadataid.metadata_id) as cnt FROM metadataid, soundings_1m s WHERE s.metadata_id = metadataid.metadata_id
union
SELECT count(metadataid.metadata_id) as cnt FROM metadataid, soundings_50cm s WHERE s.metadata_id = metadataid.metadata_id
union
SELECT count(metadataid.metadata_id) as cnt FROM metadataid, soundings_25cm s WHERE s.metadata_id = metadataid.metadata_id
)as foo),
   nb_rows_table as (
     select count(*) as cnt from pgrastertime
	)
SELECT CASE WHEN nb_rows_table.cnt = nb_deploy.cnt THEN 'The pgratertime table was completely deploy'
            WHEN nb_deploy.cnt = 0 THEN 'The pgratertime table was NEVER deploy' 
			ELSE 'The pgratertime table was PARTIALLY deploy'
	    END
FROM nb_rows_table,nb_deploy;
WITH 
  metadataid as (
	  SELECT distinct(metadata_id) as metadata_id FROM pgrastertime
  )
SELECT 7 as res, count(metadataid.metadata_id) || ' rows in soundings_16m' as cnt FROM metadataid, soundings_16m s WHERE s.metadata_id = metadataid.metadata_id
union
SELECT 6 as res, count(metadataid.metadata_id) || ' rows in soundings_8m' as cnt FROM metadataid, soundings_8m s WHERE s.metadata_id = metadataid.metadata_id
union
SELECT 5 as res,count(metadataid.metadata_id) || ' rows in soundings_4m' as cnt FROM metadataid, soundings_4m s WHERE s.metadata_id = metadataid.metadata_id
union
SELECT 4 as res,count(metadataid.metadata_id) || ' rows in soundings_2m' as cnt FROM metadataid, soundings_2m s WHERE s.metadata_id = metadataid.metadata_id
union
SELECT 3 as res,count(metadataid.metadata_id) || ' rows in soundings_1m' as cnt FROM metadataid, soundings_1m s WHERE s.metadata_id = metadataid.metadata_id
union
SELECT 2 as res,count(metadataid.metadata_id) || ' rows in soundings_50cm' as cnt FROM metadataid, soundings_50cm s WHERE s.metadata_id = metadataid.metadata_id
union
SELECT 1 as res,count(metadataid.metadata_id) || ' rows in soundings_25cm' as cnt FROM metadataid, soundings_25cm s WHERE s.metadata_id = metadataid.metadata_id
ORDER by res;
select 'The pgrastertime table containe ' || count(*) || ' rows' as nb_rows from pgrastertime;
select 'The pgrastertime table containe ' || count(distinct(metadata_id)) || ' objnam(xml files) in it.' from pgrastertime;
