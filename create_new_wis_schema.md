h1.  Create new wis Schema

This how-to allow you to create your new WIS _ad hoc_ database.

h2.  1 Create schema

The first step will be to create a schema.  We assume you create a schema in a Postgresql database that already has all dfo wis functions.  (see [[Database_overview]] overview for more info)

<pre>
CREATE SCHEMA z_test_sm;
</pre>

h2.  2 Create tables structure

Use this SQL script to create an empty wis database structure.  Before run the script, be sure to _find and replace_ the `wis.` schema keyword for your new schema name.

*NOTE:* the script is attache to this page but can change over time.  Look into the github pgrastertime for the last version of the script.
https://github.com/mapgears/pgrastertime/tree/master/sql/wis

<pre>
cp dfo_wis_soundings_1_tables_structure.sql tmp_create_schema.sql
sed -i "s/wis./z_test_sm./g" tmp_create_schema.sql
</pre>

h2.  3 Load empty tables

Run the script to create all tables in your new schema.

<pre>
psql -h 10.208.34.187 -p 5432 -U pgrastertime -W -d enav -f wis_create_schema.sql
</pre>

h2.  4 Load data

Now you can load new raster data into the database with the `pgrastertime` tool set.  See the [[Add_csar]] page for more info about this topic.

h2.  5 Database process

Run those functions to add the new loaded raster into the WIS tables (soundings_x).  The deploy function will append data into `soundinds` and will be partitioned in subtables table `soundinds_x` based on the `partition_insert_trigger` trigger.

<pre>
SELECT dfo_deploy('z_test_sm','brasdor_c_20190507_0150');
SELECT dfo_invalidate( 'z_test_sm','brasdor_c_20190507_0150','TRUE' );
</pre>

h2.  6 Add Raster Constraints

After you insert data into your empty table structure, you can add Raster Contraints to your tables.

NOTE: AddRasterConstraints() function work properly after you put some data in your wis structure.  Adding that constraint will help PostgreSQL to queried data and will guarantee that data is valid for pgraster extension.

<pre>
SELECT AddRasterConstraints('z_test_sm'::name,'soundings_16m'::name, 'rast'::name);
SELECT AddRasterConstraints('z_test_sm'::name,'soundings_8m'::name, 'rast'::name);
SELECT AddRasterConstraints('z_test_sm'::name,'soundings_4m'::name, 'rast'::name);
SELECT AddRasterConstraints('z_test_sm'::name,'soundings_2m'::name, 'rast'::name);
SELECT AddRasterConstraints('z_test_sm'::name,'soundings_1m'::name, 'rast'::name);
SELECT AddRasterConstraints('z_test_sm'::name,'soundings_50cmm'::name, 'rast'::name);
SELECT AddRasterConstraints('z_test_sm'::name,'soundings_25cmm'::name, 'rast'::name);
</pre>

h2.  7 Create most_recent tables

After the most recent table is created, you have to use this function

<pre>
SELECT dfo_create_most_recent_tables('z_test_sm','soundings_16m');
SELECT dfo_create_most_recent_tables('z_test_sm','soundings_8m');
SELECT dfo_create_most_recent_tables('z_test_sm','soundings_4m');
SELECT dfo_create_most_recent_tables('z_test_sm','soundings_2m');
SELECT dfo_create_most_recent_tables('z_test_sm','soundings_1m');
</pre>

Then use update function to update most_recent tables with your new loaded data

<pre>
SELECT dfo_update_most_recent_tables('z_test_sm','[new_data_table]');
</pre>
