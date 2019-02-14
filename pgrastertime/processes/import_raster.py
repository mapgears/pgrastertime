# -*- coding: utf-8 -*-

## from pgrastertime.data.sqla import DBSession
## from pgrastertime import CONFIG
from pgrastertime.readers import RasterReader
from pgrastertime.processes import LoadRaster
import subprocess
import sys, os

class XMLRastersObject:

    def __init__(self, xml_filename):
        self.xml_filename = xml_filename

    def insertXML(self, xml_filename):
    
        # TODO: should use SQLAlchemy
        cmd = "sh ./xml.sh " + xml_filename
        if subprocess.call(cmd, shell=True) != 0:
           return False
        return True
         
    def importRasters(self):
        
        # if not a DFO file type, exit!
        if (self.xml_filename.find(".object.xml")== -1):
            print("Not standard XML file")
            return False
    
        ## we need to find ALL raster type file (4) referenced by te XML metadata file
        raster_prefix = self.xml_filename.replace(".object.xml", "")
    
        if (os.path.isfile(raster_prefix + "_depth.tiff") and
            os.path.isfile(raster_prefix + "_mean.tiff") and
            os.path.isfile(raster_prefix + "_stddev.tiff") and
            os.path.isfile(raster_prefix + "_density.tiff")):
        
            print("All raster finded! Importing rasters of " + self.xml_filename)
        
            # It's a load Metadata in database
            if not (self.insertXML(self.xml_filename)):
                print("Fail to insert XML metadata in database")
                return False
        
            ## Import all those raster in database
            reader = RasterReader(raster_prefix + '_depth.tiff')
            LoadRaster(reader).run()
            ##reader = RasterReader(raster_prefix + '_mean.tiff')
            ##LoadRaster(reader).run()
            ##reader = RasterReader(raster_prefix + '_stddev.tiff')
            ##LoadRaster(reader).run()
            ##reader = RasterReader(raster_prefix + '_density.tiff')
            ##LoadRaster(reader).run()

            return True
        
        else:
            print("ERROR source file missing for " + xml_objfile )
            return False
