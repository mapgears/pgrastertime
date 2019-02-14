# -*- coding: utf-8 -*-

import subprocess

from pgrastertime.data.sqla import DBSession
from pgrastertime import CONFIG
from pgrastertime.processes.process import Process
import sys, os

class LoadRaster(Process):

    def run(self):
        resolutions = CONFIG['app:main'].get('output.resolutions').split(',')
        for resolution in resolutions:
            filename = self.reader.get_file(resolution=resolution)
            if not filename:
                continue

            #NOTE: sqlalchemy didn't work with large file.  Using system cmd workaround work fine 
            cmd =  "raster2pgsql -Y -a -f raster -t 100x100 -n filename " + filename +" pgrastertime > " +filename+".sql"
            if subprocess.call(cmd, shell=True) == 0:
            
                # if raster2pgsql run w/ success, we import SQL file in database
                cmd = "psql -U loader -d pgrastertime -f "+filename+".sql"
                if subprocess.call(cmd, shell=True) == 0:
                
                    ## if raster file upload w/ success, we update some metadata in DFO model
                    cmd = "psql -U loader -d pgrastertime -c \"update pgrastertime set filename = '"+ \
                          self.reader.filename+"', tile_id="+str(self.reader.id)+",resolution = "+ \
                          str(resolution)+", sys_period=tstzrange('"+str(self.reader.date)+ \
                          "', NULL) where filename = '"+filename.split("/")[-1]+ \
                          "' and resolution is null\""
                    if subprocess.call(cmd, shell=True) != 0:
                        print("fail to update matadata of tif file")