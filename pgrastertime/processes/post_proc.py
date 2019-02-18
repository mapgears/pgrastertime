# -*- coding: utf-8 -*-

## from pgrastertime.data.sqla import DBSession
from pgrastertime.readers import RasterReader
from pgrastertime.processes import LoadRaster
from pgrastertime.data.sqla import DBSession
from pgrastertime import CONFIG
import subprocess
import sys, os

class PostprocSQL:

    def __init__(self, sqlfiles):
        self.sqlfiles = sqlfiles
    
    def removedCommentedline(self,sql):
        # removed comment line in SQL file
        cleanStr = ''
        for line in sql:
           if line.lstrip().startswith('--'):
              cleanStr = cleanStr + line
        
        return cleanStr
    
    def exec_sql(self,sql):
        # TODO: should maybe use SQLAlchemy
        pg_host = CONFIG['app:main'].get('sqlalchemy.url').split('/')[2].split('@')[1].split(':')[0]
        pg_port = CONFIG['app:main'].get('sqlalchemy.url').split('/')[2].split('@')[1].split(':')[1]
        pg_dbname = CONFIG['app:main'].get('sqlalchemy.url').split('/')[3]
        pg_pw = CONFIG['app:main'].get('sqlalchemy.url').split('/')[2].split('@')[0].split(':')[1]
        pg_user = CONFIG['app:main'].get('sqlalchemy.url').split('/')[2].split('@')[0].split(':')[0]    
        
        cmd = "PGPASSWORD=" + pg_pw + " psql -U " + pg_user + " -d " + pg_dbname + " -c \"" + sql + "\""
        if subprocess.call(cmd, shell=True) != 0:
            print("Fail to run sql;" + sql)  


    def execute(self, sqlfiles,tablename):
    
        # TODO: should use SQLAlchemy
        resolutions = CONFIG['app:main'].get('output.resolutions').split(',') 
        
        # for each resolution table run SQL process
        # In each SQL file, the template name "pgrastertime" table will be replace by the 
        # target table name for each resolution.  ex: souncings_25cm, soundings_50cm, etc...
        for resolution in resolutions:
           
           #build target table name
           if resolution < 1:
               target_table = tablename + "_" + str(resolution) + "cm"
           else:
               target_table = tablename + "_" + str(resolution) + "m"
           
           # for each SQL ended by ';'
           sfile_a = sqlfiles.split(",")
           for file_ in sfile_a:
               with open(file_) as f:
                   lines = f.readlines()
                   if not line.lstrip().startswith('--'):
                       # for each SQL command ended by ';' in file
                       sqlcmd = lines.split(";")
                       for sqltmplate in sqlcmd:

                           # replace template table by target resolution table
                           sql = sqltmplate.replace("pgrastertime", target_table)
                           print(sql)
                           self.exec_sql(sql)
                           
      
