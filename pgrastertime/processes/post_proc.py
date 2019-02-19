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
           if not line.strip().startswith('--') and line.strip() != '':
              cleanStr = cleanStr + ' ' + line.strip()
        
        # remove all occurance streamed comments (/*COMMENT */) from string
        string = re.sub(re.compile("/\*.*?\*/",re.DOTALL ) ,"" ,cleanStr) 
             
        return string

    def execute(self):
        # for SQL files separated by ','
        sfile_a = self.sqlfiles.split(",")
        for file_ in sfile_a:
            with open(file_) as f:
                
                print("Start post process SQL file: " + file_)
                # transfert file in array to process each SQL command line
                sqlfile = f.readlines()
                   
                # we will need to removed all comment line (started by '--') in SQL file
                # then we split each SQL command with ';'                   
                sqlcmds = self.removedCommentedline(sqlfile).split(";")

                for cmd in sqlcmds:
                    # for each SQL command ended by ';' in file
                    sql = cmd.replace("pgrastertime", self.tablename).strip()
                    if sql != '':
                        DBSession().execute(sql)
                        DBSession().commit()
                print("Post process run successfully!")   
