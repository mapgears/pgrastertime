# pgrastertime
Script to load and manage PostGIS Raster with a time component


# INSTALL

sudo apt install python3 pip
pip install --user pipenv

Create DB
Load PostGIS extension
Load PGRaster extension


GDAL:
pipenv install
pipenv run pip install "GDAL<=$(gdal-config --version)"


alembic -c local.ini upgrade head


# Running the script

pipenv shell
python pgrastertime.py local.ini file.tif load