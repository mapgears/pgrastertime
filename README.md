# pgrastertime
Script to load and manage PostGIS Raster with a time component. This is used
to do analysis using raster data on specific data

This script will be used to load raster data in a table called `pgrastertime`.
All raster added to the database will be added with a time value. This value
will be used to query raster value at a specific time for analysis.


# Install on Ubuntu

## Python virtual environment
```
sudo apt install python3 pip python-pip
pip install --user pipenv
pipenv install
cp development.ini local.ini
```
Edit the local.ini to fit your installation

## Map Algebra 
This tool need to perform map algebra operations on raster.  We use gdal_calc.py script for this.

```
wget -O gdal_calc.py https://github.com/OSGeo/gdal/blob/master/gdal/swig/python/scripts/gdal_calc.py
```

## Update dependencies
```
pipenv shell
pipenv sync
```
*NOTE:* If GDAL Python Library fail to install do this:

```
export CPLUS_INCLUDE_PATH=/usr/include/gdal
export C_INCLUDE_PATH=/usr/include/gdal
pipenv run pip install "GDAL<=$(gdal-config --version)"
```

## Database

 - Find your Postgresql version and install

```
sudo apt-cache search postgresql
...
sudo apt-cache search postgis
...
sudo apt-get install postgresql-9.3-postgis-2.1 postgresql-9.3-postgis-2.1-scripts
```


 - Init your database

```
sudo su postgres
psql
CREATE USER loader WITH PASSWORD 'ChangeMe';
CREATE DATABASE pgraster WITH OWNER loader ENCODING 'UTF8';
\q
psql -d pgraster -U loader -c "CREATE EXTENSION postgis;"
cat  ./sql/dfo_add_conformance_band.sql ./sql/dfo_add_shoal_geom.sql ./sql/dfo_calculate_tile_extents.sql ./sql/dfo_calculate_tile_geoms.sql ./sql/dfo_delete_empty_tiles.sql ./sql/dfo_merge_bands.sql ./sql/dfo_metadata.sql ./sql/dfo_most_recent.sql ./sql/init_exta.sql  | psql pgraster -U loader -1 -f -

#to allow the deploy step.
cat ./sql/dfoTables/parent.sql ./sql/dfoTables/25cm.sql ./sql/dfoTables/50cm.sql ./sql/dfoTables/1m.sql ./sql/dfoTables/2m.sql ./sql/dfoTables/4m.sql ./sql/dfoTables/8m.sql ./sql/dfoTables/16m.sql | psql pgraster -U loader -1 -f -

```

Update database connection info in `local.ini` file


 - Load table:
 
```
alembic -c local.ini upgrade head
```

### To add new fields in the model

```
alembic --config local.ini revision --autogenerate -m "Add sys_period"
alembic -c local.ini upgrade head
```

## Running pgrastertime

```
pipenv shell
pgrastertime -h
usage: pgrastertime [-h] [--config config_file] --tablename TABLENAME
                    [--sqlfiles SQLFILES] [--dataset DATASET]
                    [--reader READER]
                    [--processing {load,xml,deploy,volume,sedimentation,validate}]
                    [--output OUTPUT] [--output-format {gtiff,pg}]
                    [--param [PARAM]] [--verbose] [--force] [--dry-run]
                    [--reset-data]

Loads raster data in Postgresql database with pgRaster extension, that can be
used for complex analytics. Temporal raster file will be added to a master
history table based on a time component.

optional arguments:
  -h, --help            show this help message and exit
  --config config_file, -c config_file
                        .ini configuration file
  --tablename TABLENAME, -t TABLENAME
                        Target raster table name in Postgresql
  --sqlfiles SQLFILES, -s SQLFILES
                        Custom SQL files script to process, separeted by
                        commas
  --dataset DATASET, -d DATASET
                        Input Dataset used as an option for processing
                        (shapefiles)
  --reader READER, -r READER
                        Reader driver options
  --processing {load,xml,deploy,volume,sedimentation,validate}, -p {load,xml,deploy,volume,sedimentation,validate}
                        Processing option
  --output OUTPUT, -o OUTPUT
                        Output format shapefiles or PostGIS table
  --output-format {gtiff,pg}, -of {gtiff,pg}
                        Output format Geotiff or PostGIS table
  --param [PARAM], -m [PARAM]
                        Option(s) input
  --verbose, -v         Verbose
  --force, -f, --force-overwrite
                        Force overwrite of the historical data
  --dry-run, -x         Run without process data and print command line and querries
  --reset-data          Erase all historical intersecting with new data
```

The `local.ini` is the default configuration file.  You can have multiple configuration file and 
can use `-c` flag to use a different one.

```
pgrastertime -c myconf_dev.ini -r ./data/ -p xml
```

*NOTE:* When use GDAL with path, add this environment variable
```
export GDAL_DATA=/usr/share/gdal/2.2/
```

## Example

First iteration of pgRastertime was designed to import your raster data in a postgresql database.  You need to 
edit your local.ini file to change your postgresql connection info, local path and postprocess file. 

```
pgrastertime -t testtable -r ./data/18g063330911_0250.object.xml -p load
```

A specific driver was added for a specific raster format define by an XML file. You can create your own 
driver in `process` folder.  As example, `xml_import.py` driver alows to import files link to a specific XML object file.

```
pgrastertime -t testtable -r ./data/18g063330911_0250.object.xml -p xml
```

You can add post process SQL script(s) to the command line (can be multiple script separated by commas).  
Postprocess script (-s option) are execute after each raster updated in table.  Use `pgrastertime` template
name and the pgrastertime script will find and replace them with your target table name of `-t` flag. 

```
pgrastertime -s  ./sql/basePostProcess.sql -t testtable -f -r ./data/ -p xml

if secteur_sondage (dfo) is loaded in db we can use postprocess.
pgrastertime -s  ./sql/postprocess.sql -t testtable -f -r ./data/ -p xml

To validate postprocess
select metadata_id,resolution , st_scalex(raster),st_area(tile_geom) ,filename ,st_numbands(raster) 
from soundingue  ;

```

 * The force `-f` optional flag is used to force overwrite the target table.  When force is not use and `-r` is a directory, all validation is made to import ONLY raster that is not already processed.  This check is made through the metadata target raster table.
 * w

You can `deploy` your pgrastertable table ( `-t` flag) to your production table through `./sql/deploy.sql` script (edit this
script for your needed).  

```
pgrastertime -p deploy -t testtable

sql validation
select count(*) from  soundings_4m; should be greater than 0
select count(*) from  soundings_error; should be 0
```

Validation script can be use and updated for your need.

```
pgrastertime -p validate -t datatest
```

This custom sedimentation process need multiple input value add with `-m` flags.  This example output the table processed with a cutome postgresql function to a tif file

```
pgrastertime -t soundings_4m -m time_start='2017-12-31' -m time_end='2018-10-22' -m resolution=4 -d ./datatest/secteur.shp -o ./datatest/sm1.tif -of gtiff -v -p sedimentation
```

In this example, the output is a Postgresql table `my_table`

```
pgrastertime -t soundings_4m -m time_start='2017-12-31' -m time_end='2018-10-22' -m resolution=4 -d ./datatest/secteur.shp -o my_table -of pg -v -p sedimentation
```

## Todo list

 * Add createdb script to add in target database all table needed for XML import type
 * Add more validations to report invalide/missing raster or fail process on XML object  
 * Add Volume  process
 * Include xml.sh process through SQLAlchemy




