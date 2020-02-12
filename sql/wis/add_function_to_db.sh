#!/bin/sh

HOST=localhost
PORT=2345
DB=sm_adhoc
USER=loader
export PGPASSWORD=ChangeMe

for file in *.sql; do 
    psql -h $HOST -p $PORT -d $DB -U $USER -f $file
    echo 'psql -h ' $HOST ' -p ' $PORT '-d ' $DB ' -U ' $USER ' -f ' $file
done
