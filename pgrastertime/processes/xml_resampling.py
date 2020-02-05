# -*- coding: utf-8 -*-

import ntpath
import os
from pathlib import Path
import subprocess
import sys
import tempfile

from sqlalchemy.exc import DatabaseError

from pgrastertime import CONFIG, ROOT
from pgrastertime.compat import fspath
from pgrastertime.data.sqla import DBSession
from pgrastertime.processes.post_proc import PostprocSQL
from pgrastertime.processes.raster2pgsql import Raster2pgsql
from pgrastertime.processes.spinner import Spinner
from pgrastertime.readers import RasterReader
from .process import PgProcess


class XML2RastersResampling(PgProcess):

    def __init__(self, xml_filename, tablename, force, sqlfiles, verbose,
                 dry_run, userparam=None):
        self.temp_files = []
        self.xml_filename = xml_filename
        self.tablename = str.lower(tablename)
        self.force = force
        self.sqlfiles = sqlfiles
        self.verbose = verbose
        self.dry_run = dry_run
        self.userparam = userparam or []

    def getParams(self, param):
        # this process need gdal_path parametre
        for userparam in self.userparam:
            try:
                k, v = userparam.split('=')
            except ValueError:
                continue
            else:
                if k.lower() == param:
                    return v

        return ''

    def insertXML(self, xml_filename):
        # this bash file create ins.sql to run
        if subprocess.call([
            'sh', fspath(ROOT / 'xml.sh'),
            xml_filename,
            self.tablename
        ]) != 0:
            print("Fail to convert xml to sql...")
            return False

        pgenv = self.get_pg_environ()

        if subprocess.call([
            'psql', '-q', '-f', self.tablename + '.sql'
        ], env=pgenv) != 0:
            print("Fail to insert sql in database...")
            return False

        os.remove(self.tablename + ".sql")

        return True

    def ifLoaded(self, rester_prefix):
        # when not force, we can check if raster to importe was already
        # processed.  We only need to double check in matadata table of the
        # target raster table, based on the prefix raster file xml object...

        # 1 extract raster ID from file name :
        #  template "../data/CA/16c/16c024217001_0025" or
        #  "../data/CA/16c/16c011110411_0250_0250.object.xml"
        raster_id = ntpath.basename(rester_prefix).rsplit("_", 1)[0]

        # 2 build SQL and querry
        # NOTE: at this stage, even at the first raster, the table is already
        # created but without any row...

        sql = "SELECT count(*) as cnt FROM {}_metadata WHERE objnam='{}'"
        sql = sql.format(self.tablename, raster_id)
        try:
            r = DBSession().execute(sql).fetchone()
            if r[0] == 0:
                return False
            else:
                return True

        except DatabaseError as error:
            print('Fail to run SQL : %s ' % (error.args[0]))
            return False

    def getTemporaryFile(self, **kwargs):
        """Create a temporary file that is deleted when the process is done"""
        file = tempfile.NamedTemporaryFile(**kwargs)
        self.temp_files.append(file)
        return file.name

    def importRasters(self):
        # if not a DFO file type, exit!
        if ('.object.xml' not in self.xml_filename):
            error = "Not standard XML file:" + self.xml_filename
            print(error)
            return error  # TODO: Exception?

        # we need to find ALL raster type file (4) referenced by te XML
        # metadata file
        raster_prefix = self.xml_filename.replace(".object.xml", "")

        if not self.force:
            if self.ifLoaded(raster_prefix):
                print("Skip file %s! Already loaded!" % raster_prefix)
                return "SUCCESS"

        if (
            os.path.isfile(raster_prefix + "_depth.tiff") and
            os.path.isfile(raster_prefix + "_mean.tiff") and
            # os.path.isfile(raster_prefix + "_stddev.tiff") and
            os.path.isfile(raster_prefix + "_density.tiff")
        ):

            print("All raster found! Importing rasters of ", self.xml_filename)

            # We need to insert the Metadata first in database.  We will use
            # some data in postprocess
            if not (self.insertXML(self.xml_filename)):
                error = "Fail to insert XML metadata in database"
                print(error)
                return error
            else:
                if self.verbose:
                    print(
                        "Insert XML metadata in metadata table successfully!"
                    )

            # OK resample all raster for all resolutions
            self.ImportXmlObject(raster_prefix)

            # here run postproc for each raster_prefix and self.tablename
            # Finaly, user create some post process SQL to run over loaded
            # table
            # User can have multiple SQL file to run
            if self.sqlfiles != '':
                spinner = Spinner()
                spinner.start()
                if self.verbose:
                    print("Post process SQL file: ", self.sqlfiles)
                head, tail = os.path.split(raster_prefix)
                PostprocSQL(
                    self.sqlfiles,
                    self.tablename,
                    tail,
                    False,
                    self.verbose
                ).execute()
                spinner.stop()

        else:
            error = "ERROR source file missing for " + self.xml_filename
            if self.verbose:
                print(error)
            return self.xml_filename

        return "SUCCESS"

    def initRasterFileDict(self):
        # init the raster dict
        resolutions = CONFIG['app:main'].get('output.resolutions').split(',')
        # raster_type = ['depth', 'density', 'mean', 'stddev']
        raster_type = ['depth', 'density', 'mean']
        raster_dict = {}

        for rtype in raster_type:
            r = 0
            raster_dict[rtype] = {}
            for resol in resolutions:
                r += 1
                raster_dict[rtype][r] = ''
        return raster_dict

    def getGDALcmd(self, gdalwarp_path, source_file, target_file, resolution,
                   resampling, sz_x=0, sz_y=0):
        # in some case we have to fix the size of the image.  gdal_calc work
        # only if image are the same dimension
        if sz_x != 0:
            size = ["-ts", str(sz_x), str(sz_y)]
        else:
            size = []

        return [
            fspath(Path(gdalwarp_path) / 'gdalwarp'),
            '-overwrite',
            '-t_srs', 'EPSG:3979',
            '-co', 'COMPRESS=DEFLATE',
            '-tap'
        ] + size + [
            '-tr', resolution, resolution,
            '-r', resampling,
            source_file,
            target_file
        ]

    def ImportXmlObject(self, raster_prefix):
        # we need the raster file dict
        resolutions = CONFIG['app:main'].get('output.resolutions').split(',')
        raster_dict = self.initRasterFileDict()

        # Check gdal_path param
        gdal_path = self.getParams('gdal_path')
        if gdal_path != '':
            # we will need to set the GDAL_DATA path
            os.environ["GDAL_DATA"] = gdal_path + '/data/'
            # and fix the path of bin file
            gdal_path = gdal_path + '/apps/'

        #  loop in all raster type
        nb_of_raster = 0
        for raster_type in ['depth', 'density', 'mean']:
            resolution_id = 0

            for i, resolution in enumerate(resolutions, start=1):
                # we create the raster object but dont wrap it
                raster_file_name_type = '{}_{}.tiff'.format(
                    raster_prefix, raster_type
                )
                reader = RasterReader(raster_file_name_type,
                                      self.tablename,
                                      False,
                                      self.force,
                                      True,
                                      gdal_path,
                                      raster_type)
                # start at the  nearest resolution
                if float(resolution) >= float(reader.resolution):

                    output_raster_filename = self.getTemporaryFile(
                        suffix='__{}__{}.tiff'.format(raster_type, resolution)
                    )  # reader.get_file(resolution)
                    # we will keep a sequential number for all resolution,
                    # 1, 2, 3, 4, 5 ...
                    resolution_id += 1
                    step1 = step2 = step2a = step2b = step3 = step4 = None

                    # cf http://10.208.34.178/projects/wis-sivn/wiki/Resampling
                    if resolution_id == 1:
                        # initial warp for reprojection.  We use nearest
                        # resample because it's the one that has less effect on
                        # the source pixel rotation/translation mainly used to
                        # align  pixels  (-tap)

                        # the use of near will  cause data loss on raster for
                        # witch the  native resolution is not one of the
                        # predefined resolution.
                        step1 = self.getGDALcmd(reader.gdalwarp_path,
                                                raster_file_name_type,
                                                output_raster_filename,
                                                resolution,
                                                'near')
                    else:
                        if raster_type == 'depth':
                            step1 = self.getGDALcmd(
                                reader.gdalwarp_path,
                                raster_dict['depth'][resolution_id-1],
                                output_raster_filename,
                                resolution,
                                'max')

                        if raster_type == 'density':
                                step1 = self.getGDALcmd(
                                    reader.gdalwarp_path,
                                    raster_dict['density'][resolution_id-1],
                                    output_raster_filename,
                                    resolution,
                                    'sum')

                        if raster_type == 'mean':
                            # http://10.208.34.178/projects/wis-sivn/wiki/Resampling
                            tmp_step1 = self.getTemporaryFile(
                                suffix='_{}_mean_step1.tiff'.format(resolution)
                            )
                            step1 = [
                                sys.executable, fspath(ROOT / 'gdal_calc.py'),
                                '--overwrite',
                                '-A', raster_dict['density'][resolution_id-1],
                                '-B', raster_dict['mean'][resolution_id-1],
                                '--calc', "nan_to_num(multiply(A,B))",
                                '--outfile', tmp_step1
                            ]
                            tmp_step2 = self.getTemporaryFile(
                                suffix="_{}_mean_step2.tiff".format(resolution)
                            )
                            step2 = self.getGDALcmd(reader.gdalwarp_path,
                                                    tmp_step1,
                                                    tmp_step2,
                                                    resolution,
                                                    'sum')

                            # # Here we need to downgrade sum resampling to
                            # # inferior resolution.
                            # # It's not possible to perform map algebra on
                            # # diferent raster dimension  (see #403)
                            # tmp_step3 = self.getTemporaryFile(suffix='.tiff')
                            # step3 = self.getGDALcmd(reader.gdalwarp_path,
                            #                  tmp_step2,
                            #                 tmp_step3,
                            #                 resolutions[i - 2],
                            #                  'near')

                            # gdal_calc -A input.tif --outfile=empty.tif
                            # --calc "A*0" --NoDataValue=0
                            step3 = [
                                sys.executable, fspath(ROOT / 'gdal_calc.py'),
                                '--overwrite',
                                '--co', 'COMPRESS=DEFLATE',
                                '-A', tmp_step2,
                                '-B', raster_dict['density'][resolution_id],
                                '--calc', "true_divide(A,B)",
                                '--outfile', output_raster_filename,
                            ]

                        if raster_type == 'stddev':
                            # http://10.208.34.178/projects/wis-sivn/wiki/Resampling
                            tmp_step1 = self.getTemporaryFile(
                                suffix="_{}_stddev_step1.tiff".format(
                                    resolution
                                )
                            )
                            step1 = [
                                sys.executable, fspath(ROOT / 'gdal_calc.py'),
                                '--overwrite',
                                '-A', raster_dict['density'][resolution_id-1],
                                '-B', raster_dict['stddev'][resolution_id-1],
                                '--calc', "nan_to_num((A-1)*(B*B))",
                                '--outfile', tmp_step1
                            ]

                            tmp_step2 = self.getTemporaryFile(
                                suffix="_{}_stddev_step2.tiff".format(
                                    resolution
                                )
                            )
                            step2 = self.getGDALcmd(reader.gdalwarp_path,
                                                    tmp_step1,
                                                    tmp_step2,
                                                    resolution,
                                                    'sum')
                            # reclass 1 - 0
                            tmp_step2a = self.getTemporaryFile(
                                suffix="_{}_stddev_step2a.tiff".format(
                                    resolution
                                )
                            )
                            step2a = [
                                sys.executable, fspath(ROOT / 'gdal_calc.py'),
                                '--overwrite',
                                '--co', 'COMPRESS=DEFLATE',
                                '-A', raster_dict['density'][resolution_id-1],
                                '--calc', "1*(A<3.4028234663852886e+38)",
                                '--outfile', tmp_step2a
                            ]

                            tmp_step2b = self.getTemporaryFile(
                                suffix="_{}_stddev_step2b.tiff".format(
                                    resolution
                                )
                            )
                            step2b = self.getGDALcmd(reader.gdalwarp_path,
                                                     tmp_step2a,
                                                     tmp_step2b,
                                                     resolution,
                                                     'sum')

                            step3 = [
                                sys.executable, fspath(ROOT / 'gdal_calc.py'),
                                '--overwrite',
                                '--co', 'COMPRESS=DEFLATE',
                                '-A', tmp_step2,
                                '-B', raster_dict['density'][resolution_id],
                                '-C', tmp_step2b,
                                '--calc', "nan_to_num(sqrt((A/(B-C))))",
                                '--outfile', output_raster_filename
                            ]

                    # we keep the file name for loading step
                    raster_dict[raster_type][resolution_id] = (
                        output_raster_filename
                    )
                    nb_of_raster += 1

                    # Run all commandline
                    if step1:
                        if self.verbose:
                            print(step1)
                            # if subprocess.call(step1, shell=True) != 0:
                            #     print("fail to run "+ step1)
                            #     return raster_file_name_type
                        # else:
                        #    stout='stdout=None'
                        if not self.dry_run:
                            if subprocess.call(step1) != 0:
                                print("fail to run ", step1)
                                return raster_file_name_type
                    if step2:
                        if self.verbose:
                            print(step2)
                        if not self.dry_run:
                            if subprocess.call(step2) != 0:
                                print("fail to run ", step2)
                                return raster_file_name_type
                    if step2a:
                        if self.verbose:
                            print(step2a)
                        if not self.dry_run:
                            if subprocess.call(step2a) != 0:
                                print("fail to run ", step2a)
                                return raster_file_name_type
                    if step2b:
                            if self.verbose:
                                print(step2b)
                            if not self.dry_run:
                                if subprocess.call(step2b) != 0:
                                    print("fail to run ", step2b)
                                    return raster_file_name_type
                    if step3:
                        if self.verbose:
                            print(step3)
                        if not self.dry_run:
                            if subprocess.call(step3) != 0:
                                print("fail to run ", step3)
                                return raster_file_name_type
                    if step4:
                        if self.verbose:
                            print(step4)
                        if not self.dry_run:
                            if subprocess.call(step4) != 0:
                                print("fail to run ", step4)
                                return raster_file_name_type

                # if float(resolution) >= float(reader.resolution):
                else:
                    # we need to store None value
                    raster_dict[raster_type][resolution_id] = 'None'

        # Now we can load in database
        i = 0
        for raster_type in ['depth', 'density', 'mean']:
            resolution_id = 0
            for resolution in resolutions:
                if float(resolution) >= float(reader.resolution):
                    resolution_id += 1
                    # if self.verbose:
                    if raster_dict[raster_type][resolution_id] != 'None':
                        i += 1
                        print("Load %s of %s" % (i, nb_of_raster))

                    r2pg = Raster2pgsql(
                        raster_dict[raster_type][resolution_id],
                        reader.tablename,
                        reader.filename,
                        reader.id,
                        reader.date,
                        resolution,
                        raster_prefix + "_" + raster_type + ".tiff",
                        self.verbose,
                        self.dry_run
                    ).run()

                    if not r2pg:
                        return raster_prefix + "_" + raster_type + ".tiff"

        return "SUCCESS"
