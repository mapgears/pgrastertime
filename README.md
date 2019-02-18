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
pipenv install requests
pip install psycopg2-binary
pip install gdal
pip install --global-option=build_ext --global-option="-I/usr/include/gdal" GDAL==`gdal-config --version`
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

# Running the script
```
pipenv shell
pgrastertime -c local.ini file.tif load
```

# Test data


First iteration of pgRastertime is design to import your raster data in a "container" database.  You need to edit your local.ini file to change your postgresql connection info. 

```
pipenv run python pgrastertime.py -t pgrastertime ./datatest xml
```

You can import a files link to a specific XML object file

```
pipenv run python pgrastertime.py -t pgrastertime ./datatest/18g153129011_0250_0250.object.xml xml
```

# Todo list

 * Add createdb script to add in target database all table needed for XML import type
 * Add more validations to report invalide/missing raster or fail process on XML object 
 * Add create table option if table didn't exist
 * The option -t is not realy useful right now.  Add [overwrite, append] option on target table 
 * Add custum post SQL process on imported raster (-p --process script1.sql,scrip2.sql)
 * Include xml.sh process through SQLAlchemy




