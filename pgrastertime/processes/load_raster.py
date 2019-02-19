# -*- coding: utf-8 -*-

import subprocess

from pgrastertime.data.sqla import DBSession
from pgrastertime import CONFIG
from pgrastertime.processes.process import Process
import sys, os

class LoadRaster(Process):

    def run(self):
        
        # if force, we will drop et rebuilt table
        if self.reader.force:
            pgrast_table = self.reader.getPgrastertimeTableStructure(self.reader.tablename)
            DBSession().execute("DROP TABLE IF EXISTS " + self.reader.tablename)
            DBSession().execute(pgrast_table)
            # We will need also to overwrite the Metadata table
            DBSession().execute("DROP TABLE IF EXISTS " + self.reader.tablename + "_metadata")
            metadata_table = self.reader.getMetadataeTableStructure(self.reader.tablename)
            DBSession().execute(metadata_table)
            DBSession().commit()
        
        resolutions = CONFIG['app:main'].get('output.resolutions').split(',')     
        
        for resolution in resolutions:
            filename = self.reader.get_file(resolution=resolution)
            
            if not filename:
                continue
            
            ## *NOTE:* sqlalchemy didn't able to manage result from some large raster file.  
            ## Using system cmd trhough psql workaround work fine.
            cmd =  "raster2pgsql -Y -a -f raster -t 100x100 -n filename " + \
                    filename +" " + self.reader.tablename + " > " +filename+".sql"           
            if subprocess.call(cmd, shell=True) == 0:
            
                # if raster2pgsql run w/ success, we import SQL file in database
                pg_host = CONFIG['app:main'].get('sqlalchemy.url').split('/')[2].split('@')[1].split(':')[0]
                pg_port = CONFIG['app:main'].get('sqlalchemy.url').split('/')[2].split('@')[1].split(':')[1]
                pg_dbname = CONFIG['app:main'].get('sqlalchemy.url').split('/')[3]
                pg_pw = CONFIG['app:main'].get('sqlalchemy.url').split('/')[2].split('@')[0].split(':')[1]
                pg_user = CONFIG['app:main'].get('sqlalchemy.url').split('/')[2].split('@')[0].split(':')[0]
                cmd = "PGPASSWORD=" + pg_pw + " psql -p " + pg_port + " -h " + pg_host + \
                      " -U " + pg_user + " -d " +  pg_dbname + \
                      " -f " + filename + ".sql"
                if subprocess.call(cmd, shell=True) == 0:
                
                    ## if raster file upload w/ success, we update some metadata in DFO model
                    sql = "UPDATE " + self.reader.tablename + " set filename = '" + \
                          self.reader.filename+"', tile_id="+str(self.reader.id)+",resolution = " + \
                          str(resolution)+", sys_period=tstzrange('"+str(self.reader.date) + \
                          "', NULL) where filename = '"+filename.split("/")[-1] + \
                          "' and resolution is null"
                    try:
                        DBSession().execute(sql)
                        DBSession().commit()                          
                    except:
                        print("fail to update matadata of tif file")
