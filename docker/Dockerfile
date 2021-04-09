FROM osgeo/gdal:ubuntu-full-latest
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y tzdata git postgresql postgis build-essential nano python3-pip

RUN git clone https://github.com/mapgears/pgrastertime && \
    pip3 install sqlalchemy && \
    pip3 install geoalchemy2 && \
    pip3 install psycopg2-binary

# dont forget attach to container run the folowing command
# cd pgrastertime
# cp development.ini local.ini
# nano local.ini
#