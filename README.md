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
python pgrastertime.py local.ini file.tif load
```
