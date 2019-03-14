# -*- coding: utf-8 -*-

import subprocess
from sqlalchemy.exc import DatabaseError
from pgrastertime.data.sqla import DBSession
from pgrastertime import CONFIG
import sys, os

class Raster2pgsql:

    def __init__(self, rasterfile, tablename, filename,  tile_id, date, resolution, source_tiff_file , verbose, dry_run):
        self.rasterfile = rasterfile
        self.tablename = tablename
        self.filename = filename
        self.tile_id = tile_id
        self.date = date
        self.resolution = resolution
        self.source_tiff_file = source_tiff_file
        self.verbose = verbose
        self.dry_run = dry_run

    def getConParam(self):
        conDic = {}
        conDic['pg_host'] = CONFIG['app:main'].get('sqlalchemy.url').split('/')[2].split('@')[1].split(':')[0]
        conDic['pg_port'] = CONFIG['app:main'].get('sqlalchemy.url').split('/')[2].split('@')[1].split(':')[1]
        conDic['pg_dbname'] = CONFIG['app:main'].get('sqlalchemy.url').split('/')[3]
        conDic['pg_pw'] = CONFIG['app:main'].get('sqlalchemy.url').split('/')[2].split('@')[0].split(':')[1]
        conDic['pg_user'] = CONFIG['app:main'].get('sqlalchemy.url').split('/')[2].split('@')[0].split(':')[0]
        return conDic
                
    def run(self):
        
        ## *NOTE:* sqlalchemy didn't able to manage result from some large raster file.  
        ## Using system cmd trhough psql workaround work fine.
        cmd_ras2pg =  "raster2pgsql -Y -a -f raster -t 100x100 -n filename %s %s > %s.sql" % (
                    self.rasterfile, self.tablename, self.rasterfile)
        
        # if raster2pgsql run w/ success, we import SQL file in database
        user_param = self.getConParam()
        cmd_psql = "PGPASSWORD=%s psql -q -p %s -h %s -U %s -d %s -f %s.sql" % (
                            user_param['pg_pw'],
                            user_param['pg_port'], 
                            user_param['pg_host'],
                            user_param['pg_user'],
                            user_param['pg_dbname'],
                            self.rasterfile)
 
        ## if raster file upload w/ success, we update some metadata in DFO model
        sql = "UPDATE " + self.tablename + " set filename = '" + \
                          self.source_tiff_file.split("/")[-1]+"', tile_id="+str(self.tile_id)+",resolution = " + \
                          str(self.resolution)+", sys_period=tstzrange('"+str(self.date) + \
                          "', NULL) where filename = '"+ self.rasterfile.split("/")[-1] + \
                          "' and resolution is null"
 
        if self.verbose:
            print(cmd_ras2pg)
            print(cmd_psql)
            print(sql)             
        
        if not self.dry_run:
            # 1. create the sql file that load the raster data
            if subprocess.call(cmd_ras2pg, shell=True) == 0:
            
                # 2. insert the raster data in database
                user_param =  self.getConParam()
                if subprocess.call(cmd_psql, shell=True) == 0:
                
                    # Ok now update the table with specific information not manage by raster2pgsql
                    try:
                        DBSession().execute(sql)
                        DBSession().commit()
                        
                        # we need to delete temp file
                        print("delete file " + self.rasterfile + ".sql")
                        os.remove(self.rasterfile + ".sql") 
                                            
                    except DatabaseError as error:
                        print('Fail to run SQL : %s ' % (error.args[0]))
                        return False

                else:
                    return False
        
        # everything is OK
        return True