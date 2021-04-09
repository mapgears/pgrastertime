# pgrastertime
Script to load raster file with a time component into Postgresql database with 
pgRaster extension. Query and analyze raster with SQL allows complex analysis 
and gives great flexibility.   This tool can help you to process source rasters
before loading step, with GDAL utility and perform post-process after loading step. 

The script will help to manage temporal information extract from your raster source
file in tzrange PostgreSQL field type.

# Install on Ubuntu

On Ubuntu, pgRastertime run in a Python virtual environment (pipenv)

## Install dependencies
```
sudo apt install python3 python3-pip python3-venv postgresql postgis gdal-bin python3-gdal build-essential libgdal-dev
git clone https://github.com/mapgears/pgrastertime
```

## Python virtual environment

We need to create a development virtual environment available only for the active user
```
cd ./pgrastertime
echo 'PATH="$HOME/.local/bin/:$PATH"' >>~/.bashrc
pip3 install --user pipenv
. ~/.profile
pipenv install
export CPLUS_INCLUDE_PATH=/usr/include/gdal
export C_INCLUDE_PATH=/usr/include/gdal
pipenv run pip install "GDAL<=$(gdal-config --version)"
pipenv shell
```

## Compile and patch GDAL 2.4  (optional)

The dfo driver needs a patched version of GDAL 2.4.  This section explain how to download
source code, apply patch and compile to run locally a patch version of GDAL.  Within the
pgrastertime command line, we will be able to point the GDAL path.

```
wget http://download.osgeo.org/gdal/2.4.0/gdal-2.4.0.tar.gz
tar xzvf gdal-2.4.0.tar.gz
cd gdal-2.4.0
patch -i ../pgrastertime/gdal-2.4-resample-sum.patch
# File to patch: ./alg/gdalwarper.cpp
# File to patch: ./alg/gdalwarper.h
# File to patch: ./alg/gdalwarpkernel.cpp
# File to patch: ./alg/gdalwarpoperation.cpp
# File to patch: ./apps/gdalwarp_bin.cpp
# File to patch: ./apps/gdalwarp_lib.cpp
./configure
make
```

# Install on Windows

This installation has been tested on Windows 10

### Install Postgresql Database

Download and install PostgreSQL from EnterpriseDB (version 10.9 tested): https://www.enterprisedb.com/downloads/postgres-postgresql-downloads

NOTE: choose your admin password and your database port

Run the **StackBuilder** utility and install the PostGIS add-on.

NOTE: Chose PostGIS bundle and clic "YES" to all installer questions

### Conda environment

The best way to run pgRastertime on Windows is to build a dedicated silo where all needed packages will be installed.  For this reason we use cross platform Conda packaging management solution.

Install the latest available Miniconda python 3 version from here :  https://conda.io/en/latest/miniconda.html
 
Open an **Anaconda Prompt Terminal** Windows (from Start menu), clone this repo first then create a new **pgrastertime** conda environment


```
cd .\pgrastertime
cp development.ini local.ini
conda create -n pgrastertime python=3.7
conda activate pgrastertime
conda install -c conda-forge --file conda-package.lst
```

# Init your database

Basic postgresql database init

```
psql -h localhost -p 5432 -U postgres -W
CREATE USER loader WITH PASSWORD 'loader';
ALTER USER loader WITH SUPERUSER;
CREATE DATABASE pgraster WITH OWNER loader ENCODING 'UTF8';
\q
psql -h localhost -p 5432 -d pgraster -U loader -W -c "CREATE EXTENSION postgis;"
psql -h localhost -p 5432 -d pgraster -U loader -W -f ./sql/init_exta.sql
```
From pgrastertime directory, copy the `development.ini` file to `local.ini` and 
edit database connection string for sqlalchemy module:

```
# This DB needs to have the PostGIS Raster extension enabled
sqlalchemy.url = postgresql://user:password@localhost:5432/pgrastertime
```

The pgrastertime script will use this connection string to connect PostgreSQL database.

Finally, DFO user will need to run those optional sql files for custom operations.

```
psql -h localhost -p 5432 -U loader -W -d pgraster -f ./sql/wis/dfo_functions.sql
psql -h localhost -p 5432 -U loader -W -d pgraster -f ./sql/wis/dfo_all_tables.sql
```

# Running pgrastertime

```
python3 pgrastertime.py -h
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
python3 pgrastertime.py -c myconf_dev.ini -r ./data/ -p xml
```


## Examples

First iteration of pgRastertime was designed to import your raster data in a postgresql database.  You need to 
edit your local.ini file to change your postgresql connection info, local path and postprocess file. 

```
python3 pgrastertime.py -f -t depth -r ./data/18g063330911_0025_depth.tiff -p load
```

A specific driver was added for a specific raster format define by an XML file produce by CARIS software. You can create your own 
driver in `process` folder.  As example, `xml_import.py` driver alows to import files link to a specific XML object file.

```
python3 pgrastertime.py -f -t testtable -r ./data/18g063330911_0250.object.xml -p xml
```

You can add post process SQL script(s) to the command line (can be multiple script separated by commas).  
Postprocess script (-s option) are execute after each raster updated in table.  Use `pgrastertime` template
name and the pgrastertime script will find and replace them with your target table name of `-t` flag. 

```
python3 pgrastertime.py -s ./sql/basePostProcess.sql -t testtable -f -r ./data/ -p xml
```

if secteur_sondage (dfo) is loaded in db we can use postprocess.
```
python3 pgrastertime.py -s  ./sql/postprocess.sql -t testtable -f -r ./data/ -p xml
```
To validate postprocess
```
select metadata_id,resolution , st_scalex(raster),st_area(tile_geom) ,filename ,st_numbands(raster) from soundingue;
```

The force `-f` optional flag is used to force overwrite the target table.  When force is not use and `-r` is a directory, all validation is made to import ONLY raster that is not already processed.  This check is made through the metadata target raster table.

You can `deploy` your pgrastertable table ( `-t` flag) to your production table through `./sql/deploy.sql` script (edit this
script for your needed).  

```
python3 pgrastertime.py -p deploy -t testtable
```

SQL for validation
```
select count(*) from  soundings_4m; should be greater than 0
select count(*) from  soundings_error; should be 0
```

Validation script can be use and updated for your need.

```
python3 pgrastertime.py -p validate -t datatest
```

This custom sedimentation process need multiple input value add with `-m` flags.  This example output the table processed with a cutome postgresql function to a tif file

```
python3 pgrastertime.py -t soundings_4m -m time_start='2017-12-31' -m time_end='2018-10-22' -m resolution=4 -d ./datatest/secteur.shp -o ./datatest/sm1.tif -of gtiff -v -p sedimentation
```

In this example, the output is a Postgresql table `my_table`

```
python3 pgrastertime.py -t soundings_4m -m time_start='2017-12-31' -m time_end='2018-10-22' -m resolution=4 -d ./datatest/secteur.shp -o my_table -of pg -v -p sedimentation
```

## Todo list

 * Add createdb script to add in target database all table needed for XML import type
 * Add more validations to report invalide/missing raster or fail process on XML object  
 * Add Volume  process
 * Include xml.sh process through SQLAlchemy


# Gdal version command line
python3 pgrastertime.py -s ./sql/basePostProcess.sql -t testtable -f -r ./data/ -p xml  -m gdal_path=gdal-2.4.0

# Docker
We built a dockerfile with the latest version of gdal osgeo / gdal: ubuntu-full-latest. Since we use
  Docker, we can remove the python environment part and run commands directly as root.
  We are also referring to another container for the postgis part which could be stacked in a stack. 
  First, create an image. The Dockerfile in the directory where file is locate.
  The content of the dockerfile
  ```
FROM osgeo/gdal:ubuntu-full-latest
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y tzdata git postgresql postgis build-essential  nano python3-pip
                                  
RUN git clone https://github.com/mapgears/pgrastertime && \
    pip3 install sqlalchemy && \
    pip3 install geoalchemy2 && \
    pip3 install psycopg2-binary


  ```
  ```
docker build -t name_of_image . 
  ```
Run the container with this images.  https://docs.docker.com/engine/reference/run/
in a shell  console do the next command

```
cd pgrastertime
cp development.ini local.ini
nano local.ini
```
replace local.ini parameters

put the coordinates of the db. 
```
postgresql://user:password@localhost:5432/pgrastertime
by
postgresql://loader:loader@ipaddress_of_posgis_db:5432/pgrastertime
```
Try some example and when this container work well, you can save the container to the new configurated image.
https://docs.docker.com/engine/reference/commandline/commit/
