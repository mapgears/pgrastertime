# pgrastertime
Script to load and manage PostGIS Raster with a time component.


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
```
export CPLUS_INCLUDE_PATH=/usr/include/gdal
export C_INCLUDE_PATH=/usr/include/gdal
pipenv run pip install "GDAL<=$(gdal-config --version)"
```

## Database
 - Create DB
 - Load PostGIS extension
 - Load PGRaster extension
 - Load table:
```
  alembic -c local.ini upgrade head
```

# Running the script
```
pipenv shell
python pgrastertime.py local.ini file.tif load
```

# To add new fields in the model
```
alembic --config local.ini revision --autogenerate -m "Add sys_period"
alembic -c local.ini upgrade head
```
