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
 - Create DB
 - Load PostGIS extension
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
pipenv run pgrastertime -h
```

## Example

First iteration of pgRastertime is design to import your raster data in a "container" database.  You need to edit your local.ini file to change your postgresql connection info, local path and postprocess file. 

```
pipenv run pgrastertime -t testtable -r ./datatest -p xml
```

You can import a files link to a specific XML object file

```
pipenv run pgrastertime -t testtable -r ./datatest/18g153129011_0250_0250.object.xml -p xml
```

You can add post process SQL script(s) to the command line and an optional flag to force overwrite the target table

```
pipenv run pgrastertime -c local.ini -s ./sql/postprocess.sql -t datatest -f -f ../../data/data_test/18g153129011_0250_0250.object.xml -p xml
```

You can add to your Raster database a production table where you can manage partition for example.  You can edit the deploy.sql script as needed

```
pipenv run pgrastertime -c local.ini -d -t datatest
```

## Todo list

 * Add createdb script to add in target database all table needed for XML import type
 * Add more validations to report invalide/missing raster or fail process on XML object  
 * Add Volume, Sedimentation process
 * Include xml.sh process through SQLAlchemy




