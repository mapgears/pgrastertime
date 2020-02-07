# -*- coding: utf-8 -*-

from pgrastertime.data.sqla import DBSession
from sqlalchemy.exc import DatabaseError
from pgrastertime.readers import RasterReader
from pgrastertime.processes import LoadRaster
from pgrastertime.processes.post_proc import PostprocSQL
from pgrastertime.processes.spinner import Spinner
from pgrastertime import CONFIG
import subprocess
import sys, os, ntpath

class XMLRastersObject:

    def __init__(self, xml_filename,tablename,force,sqlfiles, rasterfile, verbose=False):
        self.xml_filename = xml_filename
        self.tablename = tablename
        self.force = force
        self.sqlfiles = sqlfiles
        self.verbose = verbose
        self.rasterfile = rasterfile

    def getConParam(self):
        conDic = {}
        conDic['pg_host'] = CONFIG['app:main'].get('sqlalchemy.url').split('/')[2].split('@')[1].split(':')[0]
        conDic['pg_port'] = CONFIG['app:main'].get('sqlalchemy.url').split('/')[2].split('@')[1].split(':')[1]
        conDic['pg_dbname'] = CONFIG['app:main'].get('sqlalchemy.url').split('/')[3]
        conDic['pg_pw'] = CONFIG['app:main'].get('sqlalchemy.url').split('/')[2].split('@')[0].split(':')[1]
        conDic['pg_user'] = CONFIG['app:main'].get('sqlalchemy.url').split('/')[2].split('@')[0].split(':')[0]
        return conDic

    def insertXML(self, xml_filename):
        #this bash file create ins.sql to run
        cmd = "sh ./xml.sh " + xml_filename + " " + self.tablename
        if subprocess.call(cmd, shell=True) != 0:
           print("Fail to convert xml to sql...")
           return False

        con_pg = self.getConParam()
        os.environ["PGPASSWORD"] = con_pg['pg_pw']
        cmd = "psql -q -h %s -p %s -U %s -d %s -f ins.sql" % (
                     con_pg['pg_host'],
                     con_pg['pg_port'],
                     con_pg['pg_user'],
                     con_pg['pg_dbname'])
        print(cmd)
        if subprocess.call(cmd, shell=True) != 0:
             print("Fail to insert sql in database...")
             return False
        #os.remove("ins.sql")

        return True

    def ifLoaded(self,rester_prefix):
        # when not force, we can check if raster to importe was already processed.
        # We only need to double check in matadata table of the target raster table,
        # based on the prefix raster file xml object...

        # 1 extract raster ID from file name :
        #  template "../data/CA/16c/16c024217001_0025" or "../data/CA/16c/16c011110411_0250_0250.object.xml"
        raster_id = ntpath.basename(rester_prefix).rsplit("_", 1)[0]

        # 2 build SQL and querry
        # NOTE: at this stage, even at the first raster, the table is already created but without any row...
        sql = "SELECT count(*) as cnt FROM %s_metadata WHERE objnam='%s'" % (self.tablename,raster_id)
        try:
            r = DBSession().execute(sql).fetchone()
            if r[0] == 0:
                return False
            else:
                return True


        except DatabaseError as error:
            print('Fail to run SQL : %s ' % (error.args[0]))
            return False

    def importRasters(self):

        # if not a DFO file type, exit!
        if (self.xml_filename.find(".object.xml")== -1):
            error = "Not standard XML file"
            print(error)
            return error

        ## we need to find ALL raster type file (4) referenced by te XML metadata file
        raster_prefix = self.xml_filename.replace(".object.xml", "")

        if not self.force:
            if self.ifLoaded(raster_prefix):
                print("Skip file %s! Already loaded!" % raster_prefix)
                return "SUCCESS"

        if (os.path.isfile(raster_prefix + "_depth.tiff") and
            os.path.isfile(raster_prefix + "_mean.tiff") and
            #os.path.isfile(raster_prefix + "_stddev.tiff") and
            os.path.isfile(raster_prefix + "_density.tiff")):

            print("All raster finded! Importing rasters of " + self.xml_filename)

            reader = RasterReader(raster_prefix + '_depth.tiff',self.tablename, True, self.force)
            if not LoadRaster(reader).run():
                return raster_prefix + '_depth.tiff'
            reader = RasterReader(raster_prefix + '_mean.tiff',self.tablename, True, self.force)
            if not LoadRaster(reader).run():
                return raster_prefix + '_mean.tiff'
            #reader = RasterReader(raster_prefix + '_stddev.tiff',self.tablename, True, self.force)
            #if not LoadRaster(reader).run():
            #    return raster_prefix + '_stddev.tiff'
            reader = RasterReader(raster_prefix + '_density.tiff',self.tablename, True, self.force)
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
            error = "ERROR source file missing for " + self.xml_filename
            if self.verbose:
                print(error)
            return self.xml_filename

        return "SUCCESS"
