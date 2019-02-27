# -*- coding: utf-8 -*-

from pgrastertime.data.sqla import DBSession
from pgrastertime.readers import RasterReader
from pgrastertime.processes import LoadRaster
from pgrastertime.processes.post_proc import PostprocSQL
from pgrastertime.processes.spinner import Spinner
from pgrastertime import CONFIG
import subprocess
import sys, os

class XMLRastersObject:

    def __init__(self, xml_filename,tablename,force,sqlfiles, rasterfile, verbose=False):
        self.xml_filename = xml_filename
        self.tablename = tablename
        self.force = force
        self.sqlfiles = sqlfiles
        self.verbose = verbose
        self.rasterfile = rasterfile

    def insertXML(self, xml_filename):
    
        # TODO: should use SQLAlchemy
        pg_host = CONFIG['app:main'].get('sqlalchemy.url').split('/')[2].split('@')[1].split(':')[0]
        pg_port = CONFIG['app:main'].get('sqlalchemy.url').split('/')[2].split('@')[1].split(':')[1]
        pg_dbname = CONFIG['app:main'].get('sqlalchemy.url').split('/')[3]
        pg_pw = CONFIG['app:main'].get('sqlalchemy.url').split('/')[2].split('@')[0].split(':')[1]
        pg_user = CONFIG['app:main'].get('sqlalchemy.url').split('/')[2].split('@')[0].split(':')[0]
        
        #this bash file create ins.sql to run
        cmd = "sh ./xml.sh " + xml_filename + " " + self.tablename 
        if subprocess.call(cmd, shell=True) != 0:
           print("Fail to convert xml to sql...")
           return False
        
        cmd = "PGPASSWORD=" + pg_pw + " psql -q -U " + pg_user + " -d " + pg_dbname+ " -f ins.sql"
        if subprocess.call(cmd, shell=True) != 0:
             print("Fail to insert sql in database...")
             return False
        os.remove("ins.sql")
              
        return True
         
    def importRasters(self):
        
        # if not a DFO file type, exit!
        if (self.xml_filename.find(".object.xml")== -1):
            error = "Not standard XML file"
            print(error)
            return error
    
        ## we need to find ALL raster type file (4) referenced by te XML metadata file
        raster_prefix = self.xml_filename.replace(".object.xml", "")
    
        if (os.path.isfile(raster_prefix + "_depth.tiff") and
            os.path.isfile(raster_prefix + "_mean.tiff") and
            os.path.isfile(raster_prefix + "_stddev.tiff") and
            os.path.isfile(raster_prefix + "_density.tiff")):
        
            print("All raster finded! Importing rasters of " + self.xml_filename)
        
            ## Import all those raster in database
            reader = RasterReader(raster_prefix + '_depth.tiff',self.tablename,self.force)
            if not LoadRaster(reader).run():
                return raster_prefix + '_depth.tiff'
            reader = RasterReader(raster_prefix + '_mean.tiff',self.tablename,self.force)
            if not LoadRaster(reader).run():
                return raster_prefix + '_mean.tiff'
            reader = RasterReader(raster_prefix + '_stddev.tiff',self.tablename,self.force)
            if not LoadRaster(reader).run():
                return raster_prefix + '_stddev.tiff'
            reader = RasterReader(raster_prefix + '_density.tiff',self.tablename,self.force)
            if not LoadRaster(reader).run():
                return raster_prefix + '_density.tiff'
            
            # here run postproc for each raster_prefix and self.tablename
            # Finaly, user create some post process SQL to run over loaded table
            # User can have multiple SQL file to run       
            if self.sqlfiles is not None:
                spinner = Spinner()
                spinner.start()
                if self.verbose:
                    print ("Post process SQL file: " + self.sqlfiles)
                head, tail = os.path.split(raster_prefix)
                PostprocSQL(self.sqlfiles, self.tablename, tail, False, self.verbose).execute()
                spinner.stop()
         
            # OK we can insert Metadata in database
            if not (self.insertXML(self.xml_filename)):
                error = "Fail to insert XML metadata in database"
                print(error)
                return error
            else:
                if self.verbose:
                    print("Insert XML metadata in metadata table successfully!")
        
        else:
            error = "ERROR source file missing for " + xml_objfile
            if self.verbose:
                print(error)
            return xml_objfile
        
        return "SUCCESS"
