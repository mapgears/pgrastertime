#!/bin/bash

HOST=localhost
PORT=5432
DB=pgrastertime
USER=*****
export PGPASSWORD=****

if [[ $# != 2 ]]; then
    echo "Load in postgresql files located on disk"
    echo "USAGE: bash ./load_table_fileondisk.sh -[ac](append or create table) [directory]"
    exit 0
fi

if [[ "$1" -eq "-c" ]]; then
    echo 'DROP TABLE IF EXISTS fileondisk; CREATE TABLE fileondisk(name text);' > creattable.sql
    find $2 -type f -iname *.xml -printf "INSERT INTO fileondisk(name) VALUES('%f');\n" >> creattable.sql
elif [[ "$1" -eq "-a" ]]; then
    find $2 -type f -iname *.xml -printf "INSERT INTO fileondisk(name) VALUES('%f');\n" >> creattable.sql
fi

psql -h $HOST -p $PORT -d $DB -U $USER -f creattable.sql

echo '=============================================================='
echo 'Helper ... Find raster not loaded in database'
echo 'SELECT f.name FROM fileondisk f' 
echo 'LEFT JOIN metadata m ON SUBSTRING(f.name,0 , POSITION('_' in f.name)) = m.objnam'
echo 'WHERE  m.objnam IS NULL;'
