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
psql -d pgraster -U loader
CREATE EXTENSION postgis;
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
```

The `local.ini` is the default configuration file.  You can have multiple configuration file and 
can use `-c` flag to use a different one.

```
pgrastertime -c myconf_dev.ini -r ./datatest/raster.tif -p load
```

## Example

First iteration of pgRastertime was designed to import your raster data in a postgresql database.  You need to 
edit your local.ini file to change your postgresql connection info, local path and postprocess file. 

```
pgrastertime -t testtable -r ./datatest/raster.tif -p load
```

A specific driver was added for a specific raster format define by an XML file. You can create your own 
driver in `process` folder.  As example, `xml_import.py` driver alows to import files link to a specific XML object file.

```
pgrastertime -t testtable -r ./datatest/18g063120831_0025.object.xml -p xml
```

You can add post process SQL script(s) to the command line (can be multiple script separated by commas).  
Postprocess script (-s option) are execute after each raster updated in table.  Use `pgrastertime` template
name and the pgrastertime script will find and replace them with your target table name of `-t` flag. 

```
pgrastertime -s ./sql/postprocess.sql -t testtable -f -r ../data/data_test/ -p xml
```

 * The force `-f` optional flag is used to force overwrite the target table.  When force is not use and `-r` is a directory, all validation is made to import ONLY raster that is not already processed.  This check is made through the metadata target raster table.
 * w

You can `deploy` your pgrastertable table ( `-t` flag) to your production table through `./sql/deploy.sql` script (edit this
script for your needed).  

```
pgrastertime -p deploy -t testtable
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




