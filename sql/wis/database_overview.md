h1. Database overview

h2. Tuning database

The WIS database needs to be fine tune because raster needs a lot of memory. Also, ST_Union need lots of
memory. The best web page reference for this important topic is here: https://wiki.postgresql.org/wiki/Tuning_Your_PostgreSQL_Server

h3. Get the basic values

On Ubuntu box

<pre>
$ free -m
              total        used        free      shared  buff/cache   available
Mem:           3944         154        1561           0        2227        3506
Swap:          2047          49        1998

$ lscpu
Architecture:        x86_64
CPU op-mode(s):      32-bit, 64-bit
Byte Order:          Little Endian
CPU(s):              4
...
</pre>

h3. Set the main parameters

<pre>
# shared_buffers should be 25% of RAM, but no higher than 8GB.
shared_buffers = 4GB  

work_mem = 250MB

temp_buffers = 20MB

# wal_buffers should be 3% of shared_buffers up to a maximum of 16MB
wal_buffers=-1
maintenance_work_mem = 256MB
autovacuum_work_mem = -1

# effective_cache_size should be 75% of available RAM 
effective_cache_size=6GB

# based on shared_buffers
wal_buffers = -1    

</pre>

ref: https://www.manniwood.com/2005_01_01/typical_changes_to_postgresqlconf_for_large_database_installations.html
ref: http://rhaas.blogspot.com/2012/03/tuning-sharedbuffers-and-walbuffers.html


h3.  Decent debug log

<pre>
sudo vim /etc/postgresql/9.3/main/postgresql.conf
# Uncomment/Change inside:

log_min_messages = debug1
log_min_error_statement = debug5
log_min_duration_statement = -1
</pre>

h3.  Restart server

All those changes need to reboot the server
<pre>
sudo service postgresql restart
</pre>

h2.  How to debug

You can run manually all dfo_n() function in pgAdmin and view all SQL command to debug any problem in loading process.
<pre>
SET client_min_messages to 'debug';
or
SET client_min_messages to 'notice';
</pre>

_NOTE: Not all function have _RAISE DEBUG_ in but most of them_

ref: https://www.postgresql.org/docs/9.5/runtime-config-logging.html


h2. How data loading

h3. Step 1) Upload

We first upload the new Caris dataset (based on an xml file) in a temporary soundings table name.  That way it will not affect the production soundings_x tables.  At this step, we NEED to run the postprocess script on the new loaded dataset (the new temp soundings table name).  The *gdal_path* allows running a specific compile version of GDAL instead of the default installed Ubuntu version.

<pre>
python3 pgrastertime.py -s ./sql/postprocess.sql -f -t western_retry -p xml -r /home/srvlocadm/data/Western/18043/18043lh1618_r_mb_final_0050.object.xml -m gdal_path=/home/srvlocadm/gdal-2.4.0/
</pre>

_*Note 1*: Add -f to force create the table.  If the table is not created and -f is not in the command line, it will fail (bug)_ 

_*Note 2*: This command line will produce a log file (ex: pgrastertime_2019-10-11_12-37-05.log).  In the of a directory pointed as input, it will be useful to know all fail files that were not processed._


h3. Step 3) Validation 

This tool allows validating the new loaded dataset

<pre>
python3 pgrastertime.py -t western_retry -p validate
</pre>

h3. Step 2) Deploy 

This step allows pushing the newly loaded dataset into the production soundings table. Note that the same deploy command line can be more than one time, the deploy function manage it anyway.

<pre>
python3 pgrastertime.py -t western_retry -p deploy
</pre>

h3. Step 4) Clean up

<pre>
python3 pgrastertime.py -t western_retry -p delete
</pre>


h2. DFO Functions

TODO

h3. dfo_add_conformance_band() - postprocess

This function will use the design_grade table to create a new *conformance* band in the newly loaded dataset.

h3. dfo_get_conformance_band() - postprocess

This function is used by the dfo_add_conformance_band() function.

h3. dfo_add_shoal_geom() - postprocess

This function is used to calculate shoal geometries fields at all resolutions for the newly loaded dataset.

h3. dfo_calculate_tile_extents() - postprocess

This function is used to calculate tiles extent fields at all resolutions for the newly loaded dataset.

h3. dfo_calculate_tile_geoms() - postprocess

This function is used to calculate tiles geometries fields at all resolutions for the newly loaded dataset.

h3. dfo_delete_empty_tiles() - postprocess

After loading an XML raster file (from Caris) we have a lot of empty tiles. We need to delete them to keep the size of a table.

h3. dfo_metadata() - postprocess

This function is executed to update the metadata table after loading throughout the postprocess.  The metadata is the Caris XML file loaded into the master metadata table at the deploy step. 

h3. dfo_merge_bands() - postprocess

This function allows us to merge separated tile raster *mean*, *stddev* and *density* with the *depth* tile as 4 different bands.  After this process, *mean*, *stddev* and *density* raster tiles will be deleted from the newly loaded dataset.  

h3. dfo_deploy() - deploy

This function allows publishing new data loaded into a temporary table to soundings partition.

h3. dfo_invalidate() - deploy

This function allows us to set the _tzrange_ closing date if the new loaded dataset covering entierly other tiles already uploaded in soundings_[resolution] production table.  The boolean *manage_older* parameter set to *TRUE*  is needed to invalidate older tiles.  This crucial step is needed to be sure the Most recent process runs correctly.

h3. dfo_invalidate_tiles() - deploy

This function is use by dfo_invalidate() function.

h3. dfo_metadatbatch

<pre>
dfo_metadatbatch(
    soundings table name
)
</pre>

This function will update the metadata table value of all *objnam* in the soundings metadata table.  For all *objnam* find, dfo_metadata() will be called.

h3. dfo_sedimentation

<pre>
dfo_sedimentation( 
    * start date
    * end date
    * geometry to localize the area to analyze
    * table name of soundings data to analyze (soundings_x)
    * resolution on the input table name
    * table or raster file name output
    )
</pre>

This function was build to create a sedimentation dataset.  The sedimentation is the difference between the depth value of a given end date and the value of the start date. 

h3. dfo_sounding_surface()

<pre>
dfo_sounding_surface(
    * soundings table name
    * *matadata_id* or *all* 
   )
</pre>

This function will group all *tile_geom* of all specific metadata_id of a given soundings table name and will update the *sounding_surface_s* table.

NOTE: This function should create an update a table name created with the name of the input soundings table name.  

h3. dfo_sounding_age_year

<pre>
dfo_sounding_age_year(
    * year geometry to union
)
</pre>

This function needs to be executed after dfo_sounding_surface().  It will use the up to date *sounding_surface_s* table and create a geometry union of the input year.  This function will update or create matadata_id footprint a the input year into *sounding_age_year* table.


h3. dfo_sounding_age

<pre>
dfo_sounding_age(
    * start year geometry to union
)
</pre>

Need to be executed after dfo_sounding_age_year(), this function will update *sounding_age* table that contains the surface (footprint) of all soundings from the beginning of the given year.  This function will update or create *sounding_age* table.

h3. dfo_update_most_recent_tables()

This function is used to rebuild all the most recent tables after inserting new data in soundings table partition. This function is really long to run.

h3. dfo_update_soundings_tables()

NOTE: deprecated

h3. dfo_volume()

h3. partition_insert_triggerv2()

This trigger function allows storing the data in the partitioned tables based on localization.  It will use the *region_footprint* table to intersect tile extent and region footprint to find what regional area to 
match(Wester, VNSL, and Atlantic).

h3. dfo_addtoheatmap() - ?

TODO 

h3. dfo_get_tile_geom() - ?

TODO 

h3. dfo_split() - ?

TODO 

h3. dfo_split2()  - ?

TODO 

h2. Data table model

h3. soundings 

Soundings tables have their children based on the regional areas (Wester, VNSL, and Atlantic). Data is inserted through the parent table (soundings_x) and a trigger moved it into the regional table (partition_insert_triggerv2). Also, we partitioned data based on resolution.

<pre>
- - - - - - - - - - 
|   soundings     |  ->  This is the Master table but this is empty.  All the data is saved in partitioned children
- - - - - - - - - -
       |_ _ _ _
               |
               \/
          - - - - - - - - - - - - - - - - - - - -
         | Trigger: partition_insert_triggerv2   |
          - - - - - - - - - - - - - - - - - - - -
               |
               \/              
- - - - - - - - - - - - 
|   soundings_25cm     |  ->  soundings_western_25cm / soundings_vnsl_25cm / soundings_atlantic_25cm
- - - - - - - - - - - -  
    - - - - - - - - - - - -
    |   soundings_50cm    |  ->  soundings_western_50cm / soundings_vnsl_50cm / soundings_atlantic_50cm
    - - - - - - - - - - - -
        - - - - - - - - - - - -       
        |   soundings_1m      |  ->  soundings_western_1m / soundings_vnsl_1m / soundings_atlantic_1m
        - - - - - - - - - - - -      
            - - - - - - - - - - - -
            |   soundings_2m      |  ->  soundings_western_2m / soundings_vnsl_2m / soundings_atlantic_2m
            - - - - - - - - - - - -
                - - - - - - - - - - - -
                |   soundings_4m      |  ->  soundings_western_4m / soundings_vnsl_4m / soundings_atlantic_4m
                - - - - - - - - - - - -
                    - - - - - - - - - - - -
                    |   soundings_8m      |  ->  soundings_western_8m / soundings_vnsl_8m / soundings_atlantic_8m
                    - - - - - - - - - - - -
                        - - - - - - - - - - - -
                        |   soundings_16m     |  ->  soundings_western_16m / soundings_vnsl_16m / soundings_atlantic_16m
                        - - - - - - - - - - - -

</pre>

<pre>
soundings_[resolution]
(
    id integer NOT NULL,
    tile_id bigint,
    rast raster,
    resolution double precision,
    filename text COLLATE pg_catalog."default",
    sys_period tstzrange,
    tile_extent geometry(Polygon),
    tile_geom geometry(MultiPolygon),
    metadata_id character varying(100) COLLATE pg_catalog."default",
    shoal_geom geometry(MultiPolygon,3979),
    CONSTRAINT soundings_error_pk PRIMARY KEY (id)
);
</pre>
h4. Constraint

Constraints is required to ensure data quality.  Here's the list of all constraint required on all soundings tables

<pre>
    CONSTRAINT soundings_1m_pk PRIMARY KEY (id),
    CONSTRAINT enforce_nodata_values_rast CHECK (_raster_constraint_nodata_values(rast) = '{340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000,340282346638529000000000000000000000000.0000000000}'::numeric[]),
    CONSTRAINT enforce_num_bands_rast CHECK (st_numbands(rast) = 4),
    CONSTRAINT enforce_out_db_rast CHECK (_raster_constraint_out_db(rast) = '{f,f,f,f}'::boolean[]),
    CONSTRAINT enforce_pixel_types_rast CHECK (_raster_constraint_pixel_types(rast) = '{32BF,32BF,32BF,32BF}'::text[]),
    CONSTRAINT enforce_scalex_rast CHECK (round(st_scalex(rast)::numeric, 10) = round(1::numeric, 10)),
    CONSTRAINT enforce_scaley_rast CHECK (round(st_scaley(rast)::numeric, 10) = round(- 1::numeric, 10)),
    CONSTRAINT enforce_srid_rast CHECK (st_srid(rast) = 3979)
</pre>

h3. most_recent_[resolution]

The most_recent_[resolution] tables are computed after all deployed processes.  This allows us to speed up the visualization needs.
<pre>

- - - - - - - - - - - - 
|   most_recent_25cm   | 
- - - - - - - - - - - -  
    - - - - - - - - - - - -
    |   most_recent_50cm   | 
    - - - - - - - - - - - -
        - - - - - - - - - - - -       
        |  most_recent_1m      | 
        - - - - - - - - - - - -      
            - - - - - - - - - - - -
            |  most_recent_2m      | 
            - - - - - - - - - - - -
                - - - - - - - - - - - -
                |  most_recent_4m      | 
                - - - - - - - - - - - -
                    - - - - - - - - - - - -
                    |  most_recent_8m      |
                    - - - - - - - - - - - -
                        - - - - - - - - - - - -
                        |  most_recent_16m     | 
                        - - - - - - - - - - - -
</pre>


<pre>

most_recent_[resolution]
(
    rast raster,
    id integer NOT NULL,
    tile_extent geometry(Polygon,3979),
    CONSTRAINT mr1pk PRIMARY KEY (id)
)
</pre>

h3. grid

The grid tables are use in to create most recent table by dfo_update_most_recent_tables().  We have one grid table per resolution
<pre>

- - - - - - - - 
|   grid_4m   | 
- - - - - - - -  
    - - - - - - - -
    |   grid_8m   | 
    - - - - - - - - 
        - - - - - - - -      
        |  grid_16m    | 
        - - - - - - - - 
            - - - - - - - -
            |  grid_64m    | 
            - - - - - - - -
</pre>

 
<pre>
grid_[resolution]
(
    rast raster,
    tile_extent geometry(Polygon,3979),
    id integer NOT NULL DEFAULT nextval('grid_4m_id_seq'::regclass)
)
</pre>

h3. metadata

The metadata table 

<pre>
metadata
(
    dunits text COLLATE pg_catalog."default",
    hordat text COLLATE pg_catalog."default",
    hunits text COLLATE pg_catalog."default",
    objnam text COLLATE pg_catalog."default" NOT NULL,
    surath text COLLATE pg_catalog."default",
    surend text COLLATE pg_catalog."default",
    sursta text COLLATE pg_catalog."default",
    surtyp text COLLATE pg_catalog."default",
    tecsou text COLLATE pg_catalog."default",
    verdat text COLLATE pg_catalog."default",
    ch_typ text COLLATE pg_catalog."default",
    client text COLLATE pg_catalog."default",
    cretim text COLLATE pg_catalog."default",
    glocat text COLLATE pg_catalog."default",
    hcosys text COLLATE pg_catalog."default",
    idprnt text COLLATE pg_catalog."default",
    km_end text COLLATE pg_catalog."default",
    kmstar text COLLATE pg_catalog."default",
    lwschm text COLLATE pg_catalog."default",
    modtim text COLLATE pg_catalog."default",
    planam text COLLATE pg_catalog."default",
    plocat text COLLATE pg_catalog."default",
    prjtyp text COLLATE pg_catalog."default",
    srcfil text COLLATE pg_catalog."default",
    srfcat text COLLATE pg_catalog."default",
    srfdsc text COLLATE pg_catalog."default",
    srfres text COLLATE pg_catalog."default",
    srftyp text COLLATE pg_catalog."default",
    sursso text COLLATE pg_catalog."default",
    uidcre text COLLATE pg_catalog."default",
    CONSTRAINT metatadata_pkey PRIMARY KEY (objnam)
)
</pre>


h3. region_footprint 

This table is used to partition the soundings in Wester, Atlantic or VNSL
<pre>
region_footprint
(
    region text COLLATE pg_catalog."default",
    geom geometry(Polygon,3979)
)
</pre>

h3. soundings_error

Sounding data Row that raises an error throughout dfo partition_insert_triggerv2() function.  Join the  *soundings_error_reason* table for the error message.

<pre>
soundings_error
(
    id integer NOT NULL,
    tile_id bigint,
    rast raster,
    resolution double precision,
    filename text COLLATE pg_catalog."default",
    sys_period tstzrange,
    tile_extent geometry(Polygon),
    tile_geom geometry(MultiPolygon),
    metadata_id character varying(100) COLLATE pg_catalog."default",
    shoal_geom geometry(MultiPolygon,3979),
    CONSTRAINT soundings_error_pk PRIMARY KEY (id)
)
</pre>

h3. soundings_error_reason

Error message raise by database dfo partition_insert_triggerv2() function.  The ID is the soundings_x id field
<pre>
soundings_error_reason
(
    id integer,
    text text COLLATE pg_catalog."default"
)
</pre>

h3. sounding_footprint_[resolution]

Soundings footprint geometry table output by dfo_sounding_surface() function.  It will contain union geometries of all tile_geom for each sounding.

<pre>
sounding_footprint_[resolution]
(
    id bigint,
    rast_geom geometry(MultiPolygon,3979),
    filename text COLLATE pg_catalog."default",
    creatim timestamp with time zone,
    metadata_id character varying(100) COLLATE pg_catalog."default"
)
</pre>

h3. sounding_age_year_[resolution]

The table that contains a geometry union of all footprint sounding of the input year.

<pre>
sounding_age_year_[resolution]
(
    geom geometry(MultiPolygon,3979),
    year double precision
)
</pre>

h3. sounding_age

The table that contains the surface (footprint) of all soundings from the beginning of the given year. 

<pre>
sounding_age
(
    year double precision,
    geom geometry(Polygon,3979)
)
</pre>

h3. stats_result

TODO

<pre>
stats_result
(
    gid integer,
    start_chai numeric,
    end_chaini numeric,
    __gid bigint,
    geom geometry(MultiPolygon,4269),
    niveau_maintenu numeric(3,1),
    geom_3979 geometry(MultiPolygon,3979),
    maintained numeric(3,1),
    minimaldepth double precision,
    depth_stddev double precision,
    calculated_mean double precision,
    stddev double precision
)
</pre>

h3. volumes_computation_results

TODO

<pre>
volumes_computation_results
(
    gabarit text COLLATE pg_catalog."default",
    sounding text COLLATE pg_catalog."default",
    drag_id numeric(10,0),
    area_to_dredge double precision,
    volume_to_dredge double precision,
    overdredged_volume double precision,
    combined_volume numeric,
    area_to_fill numeric,
    volume_to_fill numeric
)
</pre>


h2. Database init

Le initDb contient les opérations nécessaires a l'initialisation de la base de donnée.  Ce fichier SQL est inclue dans le projet Github de pgRastertime.
https://10.208.34.179/enav/enav-etl/blob/master/wis-sivn/sql/initDb.sql

Deux items important:

* La fonction st_clip est réécrite car la solution proposé dans ce billet ne fait pas encore parti de la distribution officiel. 
https://trac.osgeo.org/postgis/ticket/3457

* Un opérateur tstz_equals a été mis en place pour permettre l'utilisation du tstz_range par mapserver.

h2. WIS Data model

Here's how to generate the WIS-SIVN PROD data model script from the Lab server.

1) Empty table:
<pre>
pg_dump -h localhost -U loader -d pgrastertime -t soundings_16m -t soundings_atlantic_16m -t soundings_vnsl_16m -t soundings_western_16m  -t soundings_8m -t soundings_atlantic_8m -t soundings_vnsl_8m -t soundings_western_8m -t soundings_4m -t soundings_atlantic_4m -t soundings_vnsl_4m -t soundings_western_4m -t soundings_1m -t soundings_atlantic_1m -t soundings_vnsl_1m -t soundings_western_1m -t soundings_50cm -t soundings_atlantic_50cm -t soundings_vnsl_50cm -t soundings_western_50cm -t soundings_25cm -t soundings_atlantic_25cm -t soundings_vnsl_25cm -t soundings_western_25cm -t metadata --schema-only > dfo_wis_soundings_data_tables_structure.sql
</pre>

2) Data table
<pre>
pg_dump -c -h localhost -U loader -d pgrastertime -t grid_4m -t grid_8m -t grid_16m -t grid_64m -t design_grade -t region_footprint > wis_data_to_process_soundings.dump
</pre>

h2. ad-hoc Data model

Here's how to generate an ad-hoc data model script from the Lab server.  In this type of use case, no need to add
the partitioned trigger to soundings table.  But you will need the data table of previous item.

<pre>
pg_dump -h localhost -U loader -d pgrastertime -t metadata -t soundings_25cm -t soundings_50cm -t soundings_1m -t soundings_2m -t soundings_4m -t soundings_8m -t soundings_16m -t most_recent_25cm -t most_recent_50cm -t most_recent_1m -t most_recent_2m -t most_recent_4m -t most_recent_8m -t most_recent_16m  --schema-only > dfo_adhoc_soundings_data_tables_structure.sql
</pre>

_*NOTE*: After running this command line, remove all _inherit_ option from the result script._ 


h2. Data transfer between server

Here's a way to transfer a huge amount of data between Postgresql database server.  The pg_dump command line need to be run through postgres linux user

<pre>
sudo su postgres
pg_dump -c -h localhost -U loader -d pgrastertime -t soundings_16m -t soundings_atlantic_16m -t soundings_vnsl_16m -t soundings_western_16m | psql -h 10.208.34.187 -p 5432 -U pgrastertime -W -d enav 
pg_dump -c -h localhost -U loader -d pgrastertime -t soundings_8m -t soundings_atlantic_8m -t soundings_vnsl_8m -t soundings_western_8m | psql -h 10.208.34.187 -p 5432 -U pgrastertime -W -d enav 
pg_dump -c -h localhost -U loader -d pgrastertime -t soundings_4m -t soundings_atlantic_4m -t soundings_vnsl_4m -t soundings_western_4m | psql -h 10.208.34.187 -p 5432 -U pgrastertime -W -d enav 
pg_dump -c -h localhost -U loader -d pgrastertime -t soundings_2m -t soundings_atlantic_2m -t soundings_vnsl_2m -t soundings_western_2m | psql -h 10.208.34.187 -p 5432 -U pgrastertime -W -d enav 
pg_dump -c -h localhost -U loader -d pgrastertime -t soundings_1m -t soundings_atlantic_1m -t soundings_vnsl_1m -t soundings_western_1m | psql -h 10.208.34.187 -p 5432 -U pgrastertime -W -d enav 
pg_dump -c -h localhost -U loader -d pgrastertime -t soundings_50cm -t soundings_atlantic_50cm -t soundings_vnsl_50cm -t soundings_western_50cm | psql -h 10.208.34.187 -p 5432 -U pgrastertime -W -d enav 
pg_dump -c -h localhost -U loader -d pgrastertime -t soundings_25cm -t soundings_atlantic_25cm -t soundings_vnsl_25cm -t soundings_western_25cm | psql -h 10.208.34.187 -p 5432 -U pgrastertime -W -d enav 
pg_dump -c -h localhost -U loader -d pgrastertime -t most_recent_25cm -t most_recent_50cm -t most_recent_1m -t most_recent_2m -t most_recent_4m -t most_recent_8m -t most_recent_16m | psql -h 10.208.34.187 -p 5432 -U pgrastertime -W -d enav

pg_dump -c -h localhost -d pgrastertime -t grid_4m -t grid_8m -t grid_16m -t grid_64m -t design_grade -t region_footprint | psql -h 10.208.34.187 -p 5432 -U pgrastertime -W -d enav
</pre>


pg_dump -c -h localhost -U loader -d pgrastertime -t grid_4m -t grid_8m -t grid_16m -t grid_64m -t design_grade -t region_footprint | psql -h 10.208.34.187 -p 5432 -U smercier -d enav pgrastertime

Or if we need to store data in a temporary file

<pre>
pg_dump -c -h localhost -U loader -d pgrastertime -t wis.most_recent_4m -t  wis.most_recent_8m -t  wis.most_recent_16m -Fc > most_recent_4m8m16m.dump
pg_dump -c -h localhost -U loader -d pgrastertime -t wis.soundings_16m -t  wis.soundings_atlantic_16m -t  wis.soundings_vnsl_16m -t  wis.soundings_western_16m -Fc > wis.soundings_16m.dump
pg_dump -c -h localhost -U loader -d pgrastertime -t wis.soundings_8m -t  wis.soundings_atlantic_8m -t  wis.soundings_vnsl_8m -t  wis.soundings_western_8m -Fc > wis.soundings_8m.dump
pg_dump -c -h localhost -U loader -d pgrastertime -t wis.soundings_4m -t  wis.soundings_atlantic_4m -t  wis.soundings_vnsl_4m -t  wis.soundings_western_4m -Fc > wis.soundings_4m.dump
</pre>

Then reload in another database

<pre>
pg_restore -W -U pgrastertime -d enav wis.s16.dump 
</pre>




Voir la tâche #467

https://10.208.34.179/enav/enav-etl/blob/master/wis-sivn/sql/init_partition_tables.sql



