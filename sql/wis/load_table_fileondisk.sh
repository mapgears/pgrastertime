#!/bin/sh

HOST=localhost
PORT=2345
DB=pgraster
USER=loader
export PGPASSWORD=ChangeMe

echo 'DROP TABLE IF EXISTS fileondisk;\nCREATE TABLE fileondisk(name text);' > creattable.sql
find /home/alessard/data/ -type f -iname *.xml -printf "INSERT INTO fileondisk(name) VALUES('%f');\n" >> creattable.sql

psql -h $HOST -p $PORT -d $DB -U $USER -f creattable.sql

echo '=============================================================='
echo 'Helper ... Find raster not loaded in database'
echo 'SELECT f.name
FROM fileondisk f 
LEFT JOIN metadata m ON SUBSTRING(f.name,0 , POSITION('_' in f.name)) = m.objnam
WHERE  m.objnam IS NULL;'
