# -*- coding: utf-8 -*-

import subprocess
from sqlalchemy.exc import DatabaseError
from pgrastertime.data.sqla import DBSession
from pgrastertime import CONFIG
import sys, os

class Raster2pgsql:

    def __init__(self, rasterfile, tablename, filename,  tile_id, date, resolution, verbose=False):
        self.rasterfile = rasterfile
        self.tablename = tablename
        self.filename = filename
        self.tile_id = tile_id
        self.date = date
        self.resolution = resolution
        self.verbose = verbose

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
        cmd =  "raster2pgsql -Y -a -f raster -t 100x100 -n filename %s %s > %s.sql" % (
                    self.filename, self.tablename, self.filename)
        
        if self.verbose:
            print(cmd)
            
        if subprocess.call(cmd, shell=True) == 0:
            
            # 2. Load database con info
            user_param =  self.getParamsDict()
            
            
            # if raster2pgsql run w/ success, we import SQL file in database
            cmd = "PGPASSWORD=%s psql -q -p %s -h %s -U %s -d %s -f %s.sql" % (
                            user_param['pg_pw'],
                            user_param['pg_port'], 
                            user_param['pg_host'],
                            user_param['pg_user'],
                            user_param['pg_dbname'],
                            filename)                  
            
            if self.verbose:
                print(cmd)
            
            if subprocess.call(cmd, shell=True) == 0:
                
                ## if raster file upload w/ success, we update some metadata in DFO model
                sql = "UPDATE " + self.tablename + " set filename = '" + \
                          self.filename+"', tile_id="+str(self.tile_id)+",resolution = " + \
                          str(self.resolution)+", sys_period=tstzrange('"+str(self.date) + \
                          "', NULL) where filename = '"+self.filename.split("/")[-1] + \
                          "' and resolution is null"
                if self.verbose:
                    print(cmd)
                try:
                    DBSession().execute(sql)
                    DBSession().commit()                          
                except DatabaseError as error:
                    print('Fail to run SQL : %s ' % (error.args[0]))
                    return False

            else:
                return False
        
        # everything is OK
        return True
        
        
   def resampling
   
             ## Import all those raster in database
        resolutions = CONFIG['app:main'].get('output.resolutions').split(',')               
            # 0.# The raster dict is the central peace of the solution
            #   # https://stackoverflow.com/questions/12167192/pythonic-way-to-create-3d-dict
            #   raster_dict = initRasterFileDict()
            #   
            # 1 for raster_type IN ['depth', 'density', 'mean', 'stddev']
            #
            # 2.  for resolution in all reolutions do
            #
            # 3.     # we will keep a sequential number for all resolution, 1, 2, 3, 4, 5 ...
            #        resolution_id += 1
            #
            # 4.     # we need the initial resolution of the raster.  It can be 25cm ou 2.5m
            #        # dataset = gdal.Open(filename, gdal.GA_ReadOnly)
            #        # resolution = self.dataset.GetGeoTransform()[1]
            #        init_resolution, resolution_id = getInitResolution(raster_file) 
            #
            #        # init_resolution can be 25cm or 2.5m
            # 5.     if init_resolution == resolution
            #        
            #            ## default methode is nearest resampling for reprojection
            #            ## this resampling is the safest one to minimize transformation raster data error
            # 6.         warp_init_raster_file = gdalwarp (source_raster_file 
            #                                              Georeferencing + 
            #                                              Pixel Alignment +
            #                                              resolution = init_resolution
            #                                              COMPRESS = DEFLAT )
            #
            #            # save the raster_file name in a dict
            #            raster_dict[raster_type][resolution_id] = warp_init_raster_file
            #
            #        ## else will be perform for resample target resolution 50cm, 1m, 2m, 4m, 8m, 16m
            # 7.     else        
            #            # raster type have diferent else process
            #
            # 8.         if raster_type == 'depth'
            #                # for source file, we need to use the sequential inferior raster file from the dict   
            #                warp_raster_file = gdalwarp ( raster_dict['depth'][resolution_id - 1] 
            #                                              Georeferencing + 
            #                                              Pixel Alignment + 
            #                                              Resampling methode MAX +
            #                                              resolution = resolution
            #                                              COMPRESS = DEFLAT )
            #
            # 9.         if raster_type == 'density'
            #                # for source file, we need to use the sequential inferior raster file from the dict   
            #                warp_raster_file = gdalwarp ( raster_dict['depth'][resolution_id - 1] 
            #                                              Georeferencing + 
            #                                              Pixel Alignment + 
            #                                              Resampling methode SUM +
            #                                              resolution = resolution
            #                                              COMPRESS = DEFLAT )
            #
            # 10.       if raster_type == 'mean'
            #                # for source file, we need to use the sequential inferior raster file from the dict
            #                # 
            #                gdal_calc.py  -A raster_dict['density'][resolution_id -1] -B input --calc="A*B" 
            #                               --output=output_step1.tif   
              
            #                output_step2.tif = gdalwarp ( output_step1.tif
            #                                              Georeferencing + 
            #                                              Pixel Alignment + 
            #                                              Resampling methode SUM +
            #                                              resolution = resolution
            #                                              COMPRESS = DEFLAT )    
            #       
            #                gdal_calc.py  -A output_step2.tif -B source_raster_file --calc="A/B" 
            #                               --output = warp_raster_file              
            # 11.       if raster_type == 'stddev'
            #                # for source file, we need to use the sequential inferior raster file from the dict
            #                # 
            #                gdal_calc.py  -A raster_dict['density'][resolution_id -1] -B input --calc="(A-1)*B" 
            #                               --output=output_step1.tif   
              
            #                output_step2.tif = gdalwarp ( output_step1.tif
            #                                              Georeferencing + 
            #                                              Pixel Alignment + 
            #                                              Resampling methode SUM +
            #                                              resolution = resolution
            #                                              COMPRESS = DEFLAT )    
            #       
            #                gdal_calc.py  -A output_step2.tif -B source_raster_file --calc="sqrt(A/(B-4))" 
            #                               --output = warp_raster_file               
            
            #               # we keep the raster definition the resuse it and load it in database at the end
            # 12.            raster_dict[raster_type][resolution_id] = warp_raster_file
            # 
            #
            #
            # 13.  # Now load in database
            #      for raster_type IN ['depth', 'density', 'mean', 'stddev']
            #           for resolution in all reolutions do
            #               resolution_id += 1
            #               importRasterFile ( raster_dict[raster_type][resolution_id]) 
        
        
