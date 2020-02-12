#!/bin/bash
EXPORT PGPASSWORD=loader
for i in `./*.sql`; do 
    psql -h localhost d smtest -U loader -W -f i
done
