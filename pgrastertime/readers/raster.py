# -*- coding: utf-8 -*-

import os
from shutil import (
    copy,
    rmtree
)
import tempfile,sys
from .reader import Reader
from osgeo import gdal
from pgrastertime import CONFIG
from datetime import datetime, timedelta


class RasterReader(Reader):

    filename = None

    def __init__(self, filename, tablename, warp, force, verbose=False, gdalwarp_path='',raster_type=''):
        self.filename = os.path.basename(filename)
        self.dirname = os.path.dirname(filename)
        self.dataset = gdal.Open(filename, gdal.GA_ReadOnly)
        self.resolution = self.dataset.GetGeoTransform()[1]
        self.size_x = self.dataset.RasterXSize
        self.size_y = self.dataset.RasterYSize
        self.extension = os.path.splitext(filename)[1]
        self.destination = tempfile.mkdtemp()
        self.date = datetime.now()
        self.tablename = str.lower(tablename)
        self.warp = warp
        self.force = force
        self.verbose = verbose
        self.gdalwarp_path = gdalwarp_path
        self.raster_type = raster_type

    def __del__(self):
        rmtree(self.destination)

    @property
    def id(self):
        # TODO
        return 1

    def getPgrastertimeTableStructure(self,target_name):
        # strucure table can be customized by user and are stored in ./sql folder
        pgrast_table = CONFIG['app:main'].get('db.pgrastertable') 
        pgrast_file = os.path.dirname(os.path.realpath(sys.argv[0])) + pgrast_table
        with open(pgrast_file) as f:
            pgrast_sql = f.readlines()
            return (''.join(pgrast_sql)).replace('pgrastertime',target_name)

    def getMetadataeTableStructure(self,target_name):
        # strucure table can be customized by user and are stored in ./sql folder
        meta_table = CONFIG['app:main'].get('db.metadatatable') 
        meta_file = os.path.dirname(os.path.realpath(sys.argv[0])) + meta_table
        with open(meta_file) as f:
            meta_sql = f.readlines()
            return (''.join(meta_sql)).replace('metadata',target_name + '_metadata')

    def get_file(self, resolution=None):
        
        if float(self.resolution) > float(resolution):
           return None
        if not resolution or float(self.resolution) == float(resolution):
          dataset = self.dataset
        
        else:
            if  float(self.resolution) < float(resolution):
                dataset = self.dataset
            else:
                fname = '{}{}'.format(self.resolution, self.extension)
                fpath = os.path.join(self.destination, fname)
                dataset=gdal.Open( fpath, gdal.GA_ReadOnly)
     
        # OK we need a tmp filename   
        filename = '{}{}'.format(self.raster_type + "_" + resolution, self.extension)
        fullpath = self.destination + "_" + filename
        self.resolution=resolution
                    
        if self.warp:
        
            #align pixels and set the destination srs
            opt = gdal.WarpOptions( resampleAlg='max',
                 xRes=resolution,
                 yRes=resolution,
                 dstSRS="EPSG:3979",
                 targetAlignedPixels=True,
                 multithread=True,
                 creationOptions=['COMPRESS=DEFLATE'] )
        
            if self.verbose:
                print ("Align pixels on resolution/Reproject with GDAL of " + self.filename)
            gdal.Warp(fullpath, dataset, options=opt)
            if self.verbose:
                print ("Processed successfully!")

        return fullpath
