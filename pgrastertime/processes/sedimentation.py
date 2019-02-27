# -*- coding: utf-8 -*-

from pgrastertime.data.sqla import DBSession
from pgrastertime.processes.spinner import Spinner
from sqlalchemy.exc import DatabaseError
from pgrastertime import CONFIG
import subprocess
import sys, os, re, tempfile
from osgeo import ogr
from osgeo import gdal

class Sedimentation:

## /*
## @time_start : Date/Time from when sedimentation analysis start
## @time_end : Date/Time from when sedimentation analysis ends
## @geom : Geometry where to perform the analysis
## @raster_tablename : Master raster table to used
## @resolution : Target resolution of the tablename
## @output_name : output name
## @output_type : Supported output are shapefiles and Postgresql table
## */

    def __init__(self, raster_table, param, geometry_file, \
                 output, output_format, verbose=False):
        self.raster_table = raster_table
        self.param = param
        self.geometry_file = geometry_file 
        self.output = output
        self.output_format = output_format
        self.verbose = verbose

    def postgresToTiff(self,raster_tablename):
        # get PG con param in local.ini file

        conStr = self.serverInitCon()
        
        # add tablename and mode to PG connection string
        conStrMode = "%s table=%s mode=2" % (conStr,raster_tablename)

        # run gdal_translate
        src_ds = gdal.Open(conStrMode)
        ds = gdal.Translate(self.output, src_ds, format = 'GTiff')
        if ds is None:
            print("Fail to export...")
            return False  
        else:
            ds = None
            return True

    def importShapefile(self,serverDS, table, sourceFile):
    
        ogr.RegisterAll()
        shapeDS = ogr.Open(sourceFile)
        sourceLayer = shapeDS.GetLayerByIndex(0)
        dest_srs = ogr.osr.SpatialReference()
        dest_srs.ImportFromEPSG(3979)
        options = ['GEOMETRY_NAME=geom']
        newLayer = serverDS.CreateLayer(table,dest_srs,ogr.wkbUnknown,options)
        for x in range(sourceLayer.GetLayerDefn().GetFieldCount()):
            newLayer.CreateField(sourceLayer.GetLayerDefn().GetFieldDefn(x))

        newLayer.StartTransaction()
        for x in range(sourceLayer.GetFeatureCount()):
            newFeature = sourceLayer.GetNextFeature()
            newFeature.SetFID(-1)
            newLayer.CreateFeature(newFeature)
            if x % 128 == 0:
                newLayer.CommitTransaction()
                newLayer.StartTransaction()
        newLayer.CommitTransaction()
        return newLayer.GetName()

    def serverInitCon(self):
       # get PG con param in local.ini file
       con_pg = self.getConParam()     
       connectionString = "PG:dbname='%s' host='%s' port='%s' user='%s' password='%s'" %(
                           con_pg['pg_dbname'],
                           con_pg['pg_host'],
                           con_pg['pg_port'],
                           con_pg['pg_user'],
                           con_pg['pg_pw'])
       return connectionString
  
    def getParamsDict(self):
        # this process need 3 parametres and be sure all param name are lowercase
        # 1) time_start, time_end, resolution
        if len(self.param)!=3:
            return False
        
        op = {}    
        params = self.param
        for i in self.param:
            if i.split("=")[0].lower() == "time_start":
                op['time_start'] = i.split("=")[1] 
            elif i.split("=")[0].lower() == "time_end":
                op['time_end'] = i.split("=")[1]
            elif i.split("=")[0].lower() == "resolution":
                op['resolution'] = i.split("=")[1]

        # again we need our 3 params
        if len(op)!=3:
            return False
                                       
        return op
    def getConParam(self):
        conDic = {}
        conDic['pg_host'] = CONFIG['app:main'].get('sqlalchemy.url').split('/')[2].split('@')[1].split(':')[0]
        conDic['pg_port'] = CONFIG['app:main'].get('sqlalchemy.url').split('/')[2].split('@')[1].split(':')[1]
        conDic['pg_dbname'] = CONFIG['app:main'].get('sqlalchemy.url').split('/')[3]
        conDic['pg_pw'] = CONFIG['app:main'].get('sqlalchemy.url').split('/')[2].split('@')[0].split(':')[1]
        conDic['pg_user'] = CONFIG['app:main'].get('sqlalchemy.url').split('/')[2].split('@')[0].split(':')[0]
        return conDic
         
    def run(self):
        
        # init the spiner for futur use
        spinner = Spinner()
    
        # 1. need 3 options: time start, time end, e
        user_param =  self.getParamsDict()
        print(user_param)
         
        # 2. Load the geometry in database
        conStr = self.serverInitCon()
        ogrCon = ogr.Open(conStr)
        
        # generate a tmp name table
        tmp_tablename_geom = "t" + next(tempfile._get_candidate_names())
        r = self.importShapefile (ogrCon, tmp_tablename_geom, self.geometry_file)
        print ("Tamporary table loaded: %s" % r)
    
        # if output is a tiff, create a tmp pg table name
        if self.output_format == 'gtiff':
            raster_tablename = "t" + next(tempfile._get_candidate_names())
        else:
            raster_tablename = self.output
    
        # 3. define sedimentation querry
        #  SELECT dfo_sedimentation ('2017-12-31' , '2018-10-22' ,
        #                            (SELECT st_union(geom_3979) from secteur_sondage where gid =100 ) ,
        #                            'soundings_4m',4,'t_sortie' )
        sql = "SELECT dfo_sedimentation ('%s', '%s', (SELECT st_union(geom) from %s), '%s',%s,'sedim_%s')" %(  
                                           user_param['time_start'],
                                           user_param['time_end'],
                                           tmp_tablename_geom, 
                                           self.raster_table,
                                           user_param['resolution'],
                                           raster_tablename )
        
        if self.verbose:
           print(sql)
           
        # 4. build the sedimentation table based on PostGIS function
        try:
            spinner.start()
            r = DBSession().execute(sql)
            DBSession().commit()
            
            # 5.  if output type is a tiff, process the export
            #     and delete temp raster table.
            if self.output_format == 'gtiff':
                if self.postgresToTiff("sedim_" + raster_tablename):
                    print("Output file %s" % self.output)
                    sql = "DROP TABLE sedim_%s" % raster_tablename
                    DBSession().execute(sql)
                    DBSession().commit()
            
            elif self.output_format == 'pg':
               print("Table output: sedim_%s" % self.output) 
                
                        
            # 5. everything is OK, we drop de tmp Dataset on PG
            ogrCon.DeleteLayer(tmp_tablename_geom)
            
            spinner.stop()
                            
        except DatabaseError as error:
            print('Fail to run SQL : %s ' % (error.args[0]))
            spinner.stop()
            return False
                            
        print(" Sedimentation process run successfully!")
        
