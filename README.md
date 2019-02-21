# pgrastertime
Script to load and manage PostGIS Raster with a time component. This is used
to do analysis using raster data on specific data

This script will be used to load raster data in a table called `pgrastertime`.
All raster added to the database will be added with a time value. This value
will be used to query raster value at a specific time for analysis.


# INSTALL

## Python virtual environment
```
sudo apt install python3 pip
pip install --user pipenv
pipenv install
cp development.ini local.ini
```
Edit the local.ini to fit your installation

## Update dependencies
```
pipenv sync
```

## GDAL:
Require GDAL >= 2.1
```
export CPLUS_INCLUDE_PATH=/usr/include/gdal
export C_INCLUDE_PATH=/usr/include/gdal
pipenv run pip install "GDAL<=$(gdal-config --version)"
```

## Database

 - Search your Postgresql version and install

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

## Running the script

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
pipenv run pgrastertime -t testtable -r ./datatest/raster.tif -p load
```

A specific driver was added for a specific raster format define by an XML file. You can create your own 
driver in `process` folder.  As example, `xml_import.py` driver alows to import files link to a specific XML object file.

```
pipenv run pgrastertime -t testtable -r ./datatest/18g153129011_0250_0250.object.xml -p xml
```

You can add post process SQL script(s) to the command line (can be multiple script separated by commas).  
Postprocess script (-s option) are execute after each raster updated in table.  Use `pgrastertime` template
name and the pgrastertime script will find and replace them with your target table name (-t option). 

```
pipenv run pgrastertime -c local.ini -s ./sql/postprocess.sql -t datatest -f -r ../data/data_test/18g153129011_0250_0250.object.xml -p xml
```
*NOTE:* optional flag to force overwrite the target table

You can `deploy` your pgrastertable (-t option) to your production table through `./sql/deploy.sql` script (edit this
script for your needed).  

```
pipenv run pgrastertime -c local.ini -p deploy -t datatest
```

Validation script can be use and updated for your need.

```
pipenv run pgrastertime -c local.ini -p validate -t datatest
```




## Todo list

 * Add createdb script to add in target database all table needed for XML import type
 * Add more validations to report invalide/missing raster or fail process on XML object  
 * Add Volume, Sedimentation process
 * Include xml.sh process through SQLAlchemy




