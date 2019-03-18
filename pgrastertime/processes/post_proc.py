# -*- coding: utf-8 -*-

from pgrastertime.readers import RasterReader
from pgrastertime.processes import LoadRaster
from pgrastertime.data.sqla import DBSession
from sqlalchemy.exc import DatabaseError
from pgrastertime import CONFIG
import subprocess
import sys, os, re

class PostprocSQL:

    def __init__(self, sqlfiles, tablename, rasterfile, show_result=False,verbose=False):
        self.sqlfiles = sqlfiles
        self.tablename = tablename
        self.rasterfile = rasterfile
        self.show_result = show_result
        self.verbose = verbose
    
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

                # transfert file in array to process each SQL command line
                sqlfile = f.readlines()
                   
                # we will need to removed all comment line (started by '--') in SQL file
                # then we split each SQL command with ';'                   
                sqlcmds = self.removedCommentedline(sqlfile).split(";")

                for cmd in sqlcmds:
                    # for each SQL command ended by ';' in file
                    sql = cmd.replace("pgrastertime", self.tablename).strip()
                    
                    # postproc need a specific flag that will help to optimize the post process.
                    # Without this flag, when pgrastertime run over large volume of file, the post proc 
                    # will take toooo much time.
                    if self.rasterfile is not None:
                        sql = sql.replace("rasterfile", self.rasterfile)
                    if sql != '':
                        if self.verbose:
                            print(sql)
                        try:
                            r = DBSession().execute(sql)
                            if self.show_result:
                                for row in r:
                                    print (row)

                            # in case of update/insert/delete/drop
                            DBSession().commit()
                            
                        except DatabaseError as error:
                            print('Fail to run SQL : %s ' % (error.args[0]))
                            return False
                            
                print("\n Post process run successfully!")