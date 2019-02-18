# -*- coding: utf-8 -*-

import subprocess

from pgrastertime.data.sqla import DBSession
from pgrastertime import CONFIG
from pgrastertime.processes.process import Process
import sys, os

class LoadRaster(Process):

    def run(self):
        
        resolutions = CONFIG['app:main'].get('output.resolutions').split(',')     
        pg_host = CONFIG['app:main'].get('sqlalchemy.url').split('/')[2].split('@')[1].split(':')[0]
        pg_port = CONFIG['app:main'].get('sqlalchemy.url').split('/')[2].split('@')[1].split(':')[1]
        pg_dbname = CONFIG['app:main'].get('sqlalchemy.url').split('/')[3]
        pg_pw = CONFIG['app:main'].get('sqlalchemy.url').split('/')[2].split('@')[0].split(':')[1]
        pg_user = CONFIG['app:main'].get('sqlalchemy.url').split('/')[2].split('@')[0].split(':')[0]
        
        for resolution in resolutions:
            filename = self.reader.get_file(resolution=resolution)
            
            if not filename:
                continue
            
            # if force, we will drop et rebuilt table
            if self.reader.force:
                DBSession().execute("DROP TABLE IF EXISTS " + self.reader.tablename)
                pgrast_table = self.reader.getPgrastertimeTableStructure(self.reader.tablename)
                print(pgrast_table)
                rs = DBSession().execute(pgrast_table)
                print (rs)
                exit()
            
            #NOTE: sqlalchemy didn't work with large file.  Using system cmd workaround work fine
            cmd =  "raster2pgsql -Y -a -f raster -t 100x100 -n filename " + filename +" " + self.reader.tablename + " > " +filename+".sql"           
            if subprocess.call(cmd, shell=True) == 0:
            
                # if raster2pgsql run w/ success, we import SQL file in database
                cmd = "PGPASSWORD=" + pg_pw + " psql -U " + pg_user + " -d " + pg_dbname + " -f " + filename + ".sql"
                if subprocess.call(cmd, shell=True) == 0:
                
                    ## if raster file upload w/ success, we update some metadata in DFO model
                    # TODO: should use SQLAlchemy
                    cmd = "PGPASSWORD=" + pg_pw + " psql -U " + pg_user + " -d " + pg_dbname + " -c \"update " + \
                          self.reader.tablename + " set filename = '" + \
                          self.reader.filename+"', tile_id="+str(self.reader.id)+",resolution = " + \
                          str(resolution)+", sys_period=tstzrange('"+str(self.reader.date) + \
                          "', NULL) where filename = '"+filename.split("/")[-1] + \
                          "' and resolution is null\""
                          
                    if subprocess.call(cmd, shell=True) != 0:
                        print (cmd)
                        print("fail to update matadata of tif file")
