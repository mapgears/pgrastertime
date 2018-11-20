# -*- coding: utf-8 -*-

import os
from shutil import (
    copy,
    rmtree
)
import tempfile
from .reader import Reader
from osgeo import gdal
from datetime import datetime


class RasterReader(Reader):

    filename = None

    def __init__(self, filename):
        self.filename = filename
        self.dataset = gdal.Open(filename, gdal.GA_ReadOnly)
        self.resolution = self.dataset.GetGeoTransform()[1]
        self.extension = os.path.splitext(filename)[1]
        self.destination = tempfile.mkdtemp()

        # set date from filename
        # TODO
        self.date = datetime.now()

    def __del__(self):
        rmtree(self.destination)

    def get_file(self, resolution=None):
        if not resolution or self.resolution == resolution:
            return copy(self.filename, self.destination)

        if self.resolution > float(resolution):
            return None

        filename = '{}.{}'.format(resolution, self.extension)
        fullpath = os.path.join(self.destination, filename)
        opt = gdal.TranslateOptions(
            resampleAlg='bilinear',
            xRes=self.resolution,
            yRes=self.resolution,
            creationOptions=['COMPRESS=DEFLATE']
        )
        gdal.Translate(fullpath, self.dataset, options=opt)
        return fullpath
