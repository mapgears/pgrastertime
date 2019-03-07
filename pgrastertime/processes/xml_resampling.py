# -*- coding: utf-8 -*-

from pgrastertime.data.sqla import DBSession
from sqlalchemy.exc import DatabaseError
from pgrastertime.readers import RasterReader
from pgrastertime.processes import LoadRaster
from pgrastertime.processes.post_proc import PostprocSQL
from pgrastertime.processes.raster2pgsql import Raster2pgsql
from pgrastertime.processes.spinner import Spinner
from pgrastertime import CONFIG
import subprocess
import sys, os, ntpath, tempfile

class XML2RastersResampling:

    def __init__(self, xml_filename, tablename, force, sqlfiles, rasterfile, verbose=False):
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
        cmd = "PGPASSWORD=%s psql -q -h %s -p %s -U %s -d %s -f ins.sql" % (
                     con_pg['pg_pw'],
                     con_pg['pg_host'],
                     con_pg['pg_port'],
                     con_pg['pg_user'],
                     con_pg['pg_dbname'])
                     
        if subprocess.call(cmd, shell=True) != 0:
             print("Fail to insert sql in database...")
             return False
        os.remove("ins.sql")
              
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
            os.path.isfile(raster_prefix + "_stddev.tiff") and
            os.path.isfile(raster_prefix + "_density.tiff")):
        
            print("All raster finded! Importing rasters of " + self.xml_filename)
            
            # OK resample all raster for all resolutions
            self.ImportXmlObject(raster_prefix)
            
            # here run postproc for each raster_prefix and self.tablename
            # Finaly, user create some post process SQL to run over loaded table
            # User can have multiple SQL file to run       
            if self.sqlfiles != '':
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

    def initRasterFileDict(self):
        # init the raster dict
        resolutions = CONFIG['app:main'].get('output.resolutions').split(',')
        raster_type = ['depth', 'density', 'mean', 'stddev']
        raster_dict = {}
        
        for rtype in raster_type:
            r = 0
            raster_dict[rtype] = {}
            for resol in resolutions:
                r +=1
                raster_dict[rtype][r] = '' 
        return raster_dict    

    def getGDALcmd(self, gdalwarp_path, source_file, target_file, resolution, resampling):
    
        cmd =  "%sgdalwarp -t_srs EPSG:3979 -co COMPRESS=DEFLATE -tap -tr %s %s -r %s %s %s" % (
                     gdalwarp_path,
                     resolution,
                     resolution,
                     resampling,
                     source_file,
                     target_file)
        return cmd
         
        
    def ImportXmlObject(self, raster_prefix):


        # we need the raster file dict
        resolutions = CONFIG['app:main'].get('output.resolutions').split(',')
        raster_dict = self.initRasterFileDict()
        
        
        #  loop in all raster type
        for raster_type in ['depth', 'density', 'mean', 'stddev']:
            resolution_id = 0
            for resolution in resolutions:
                
               # we create the raster object but dont wrap it
               raster_file_name_type = raster_prefix + "_" + raster_type + ".tiff"
               reader = RasterReader(raster_file_name_type , self.tablename, False, self.force, True, '/home/srvlocadm/gdal-2.4.0/apps/')
               
               # start to process from initial resolution of the raster.  It can be 25cm ou 2.5m               
               if float(resolution) >= float(reader.resolution):
                   
                   output_raster_filename = reader.get_file(resolution)
                   
                   # we will keep a sequential number for all resolution, 1, 2, 3, 4, 5 ...
                   resolution_id += 1
                   step1=step2=step3=''
                    ## see http://10.208.34.178/projects/wis-sivn/wiki/Resampling                   
                   if resolution_id == 1:
                       # initial warp for reprojection.  We use nearest resample because it's the one
                       # that has less effect on the source pixel rotation/translation
                       # see http://10.208.34.178/projects/wis-sivn/wiki/Resampling
                       
                       # if we're in 2.5 roslution be aware to manage it
                       if reader.resolution == 2.5:
                           init_res = 2.5 
                       else:
                           init_res = resolution
                           
                       step1 = self.getGDALcmd(reader.gdalwarp_path, 
                                             raster_file_name_type,
                                             output_raster_filename,
                                             init_res,
                                             'near')
                   
                   else:
                        ## see http://10.208.34.178/projects/wis-sivn/wiki/Resampling
                       if raster_type == 'depth':
                           step1 = self.getGDALcmd(reader.gdalwarp_path, 
                                             raster_file_name_type,
                                             output_raster_filename,
                                             resolution,
                                             'max')
                       
                       if raster_type == 'density':
                            step1 = self.getGDALcmd(reader.gdalwarp_path, 
                                             raster_file_name_type,
                                             output_raster_filename,
                                             resolution,
                                             'sum')                     

                       if raster_type == 'mean':
                           ## see http://10.208.34.178/projects/wis-sivn/wiki/Resampling
                           tmp_step1 = tempfile.NamedTemporaryFile().name + ".tiff"
                           step1 = "python gdal_calc.py -A %s -B %s --calc='%s' --outfile='%s'" % (
                                          raster_dict['density'][resolution_id-1],
                                          raster_dict['mean'][resolution_id-1],
                                          "A*B",
                                          tmp_step1)
                           tmp_step2 = tempfile.NamedTemporaryFile().name + ".tiff"   
                           step2 = self.getGDALcmd(reader.gdalwarp_path, 
                                             tmp_step1,
                                             tmp_step2,
                                             resolution,
                                             'sum') 
                           step3 = "python gdal_calc.py -A %s -B %s --calc='%s' --outfile='%s'" % (
                                          tmp_step2,
                                          raster_dict['mean'][resolution_id-1],
                                          "A/B",
                                          output_raster_filename)
 
                       if raster_type == 'stddev':
                           ## see http://10.208.34.178/projects/wis-sivn/wiki/Resampling
                           tmp_step1 = tempfile.NamedTemporaryFile().name + ".tiff"
                           step1 = "python gdal_calc.py -A %s -B %s --calc='%s' --outfile='%s'" % (
                                          raster_dict['density'][resolution_id-1],
                                          raster_dict['stddev'][resolution_id-1],
                                          "(A-1)*B",
                                          tmp_step1)
                           
                           tmp_step2 = tempfile.NamedTemporaryFile().name + ".tiff"   
                           step2 = self.getGDALcmd(reader.gdalwarp_path, 
                                             tmp_step1,
                                             tmp_step2,
                                             resolution,
                                             'sum')  
                           step3 = "python gdal_calc.py -A %s -B %s --calc='%s' --outfile='%s'" % (
                                          tmp_step2,
                                          raster_dict['mean'][resolution_id-1],
                                          "sqrt(A/(B-4)",
                                          output_raster_filename)
                   
                   # we keep the file name for loading step
                   raster_dict[raster_type][resolution_id] = output_raster_filename

                   # Run all commandline
                   if step1 != '':
                       print(step1)
                       #if subprocess.call(step1, shell=True) != 0:
                       #    print("fail to run "+ step1)
                       #    return raster_file_name_type
                   if step2 != '':
                       print(step2)
                       #if subprocess.call(step2, shell=True) != 0:
                       #    print("fail to run "+ step2)
                       #    return raster_file_name_type
                   if step3 != '':
                       print(step3)
                       #if subprocess.call(step3, shell=True) != 0:
                       #    print("fail to run "+ step3)
                       #    return raster_file_name_type                                             


        #Now we can load in database
        for raster_type in ['depth', 'density', 'mean', 'stddev']:
            resolution_id = 0
            for resolution in resolutions:
                resolution_id += 1
                #Raster2pgsql( raster_dict[raster_type][resolution_id], 
                #                                reader.tablename,
                #                                reader.filename,  
                #                                reader.id, 
                #                                reader.date, 
                #                                reader.resolution, 
                #                                True).run()
                print("raster_dict[raster_type][resolution_id]=%s \n tablename=%s \n filename=%s \n id=%s \n date=%s \n resolution=%s" %( raster_dict[raster_type][resolution_id], reader.tablename, reader.filename,reader.id,reader.date,reader.resolution))
        
        return "SUCCESS"
        