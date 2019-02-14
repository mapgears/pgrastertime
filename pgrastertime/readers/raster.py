# -*- coding: utf-8 -*-

import os
from shutil import (
    copy,
    rmtree
)
import tempfile
from .reader import Reader
from osgeo import gdal
from datetime import datetime, timedelta


class RasterReader(Reader):

    filename = None

    def __init__(self, filename):
        self.filename = os.path.basename(filename)
        self.dirname = os.path.dirname(filename)
        self.dataset = gdal.Open(filename, gdal.GA_ReadOnly)
        self.resolution = self.dataset.GetGeoTransform()[1]
        self.extension = os.path.splitext(filename)[1]
        self.destination = tempfile.mkdtemp()
        self.date = datetime.now()

    def __del__(self):
        rmtree(self.destination)

    @property
    def id(self):
        # TODO
        return 1

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
        
        #align pixels and set the destination srs
        opt = gdal.WarpOptions( resampleAlg='max',
                 xRes=resolution,
                 yRes=resolution,
                 dstSRS="EPSG:3979",
                 targetAlignedPixels=True,
                 multithread=True,
                 creationOptions=['COMPRESS=DEFLATE'] )


        filename = '{}{}'.format(resolution, self.extension)
        fullpath = os.path.join(self.destination, filename)
        self.resolution=resolution
        print ("Align pixels and set the destination srs of "+filename)
        gdal.Warp(fullpath, dataset, options=opt)

        return fullpath


