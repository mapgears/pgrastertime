# -*- coding: utf-8 -*-

## from pgrastertime.data.sqla import DBSession
from pgrastertime.readers import RasterReader
from pgrastertime.processes import LoadRaster
from pgrastertime.data.sqla import DBSession
from pgrastertime import CONFIG
import subprocess
import sys, os, re

class PostprocSQL:

    def __init__(self, sqlfiles,tablename):
        self.sqlfiles = sqlfiles
        self.tablename = tablename
    
    def removedCommentedline(self,sql):
        # removed comment line in SQL file
        cleanStr = ''
        
        for line in sql:
           ##print('line:'+line)
           if not line.strip().startswith('--'):
              cleanStr = cleanStr + ' ' + line.strip()
        
        # remove all occurance streamed comments (/*COMMENT */) from string
        string = re.sub(re.compile("/\*.*?\*/",re.DOTALL ) ,"" ,cleanStr) 
             
        return string
    
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

    def execute(self):
        # for SQL files separated by ','
        sfile_a = self.sqlfiles.split(",")
        for file_ in sfile_a:
            with open(file_) as f:
               
                # transfert file in array to process each SQL command line
                sqlfile = f.readlines()
                   
                # we will need to removed all comment line (started by '--') in SQL file
                # then we split each SQL command with ';'
                # sqlcmds = self.removedCommentedline(sqlfile).split(";")
                   
                sqlcmds = self.removedCommentedline(sqlfile).split(";")

                for cmd in sqlcmds:
                    # for each SQL command ended by ';' in file
                    sql = cmd.replace("pgrastertime", target_table)
                    print(cmd)
                    ##DBSession().execute(sql)