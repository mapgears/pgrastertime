"""
Loads raster data in Postgresql database with pgRaster extension, that can be used for complex analytics.
Temporal raster file will be added to a master history table based on a time component.
"""

import argparse, os, sys, time, glob

from pgrastertime import init_config
from pgrastertime.readers import RasterReader
from pgrastertime.processes import LoadRaster
from pgrastertime.processes import PostprocSQL
from pgrastertime.processes.spinner import Spinner
from pgrastertime.data.models import SQLModel

#custom class
from pgrastertime.processes.xml_import import XMLRastersObject
from pgrastertime.processes.xml_resampling import XML2RastersResampling
from pgrastertime.processes.sedimentation import Sedimentation

root = os.path.dirname(os.path.dirname(__file__))


def parse_arguments():
    parser = argparse.ArgumentParser(description=__doc__)

    parser.add_argument(
        'config_file',
        nargs='?', help=argparse.SUPPRESS,
        default=os.path.join(root, 'local.ini'),
    )
    parser.add_argument(
        '--config', '-c', dest='config_file',
        help='.ini configuration file', metavar='config_file',
    )
    parser.add_argument(
        '--tablename', '-t',default='', required=True,
        help="Target raster table name in Postgresql"
    )
    parser.add_argument(
        '--sqlfiles', '-s', default='', 
        help="Custom SQL files script to process, separeted by commas"
    )
    parser.add_argument(
        '--dataset', '-d', default='', 
        help="Input Dataset used as an option for processing (shapefiles)"
    )
    parser.add_argument(
        '--reader', '-r', default='',
        help='Reader driver options',
    )
    parser.add_argument(
        '--processing', '-p', default='',  choices=['load', 'xml', 'deploy', 'volume', 'sedimentation', 'validate'],
        help='Processing option',
    )
    parser.add_argument(
        '--output', '-o', default='', 
        help='Output format shapefiles or PostGIS table'
    )
    parser.add_argument(
        '--output-format', '-of', default='', choices=['gtiff', 'pg'],
        help='Output format Geotiff or PostGIS table'
    )
    parser.add_argument(
        '--param', '-m', nargs='?', action='append',
        help='Option(s) input'
    )
    parser.add_argument(
        '--verbose', '-v',
        action='count', default=0,
        help="Verbose"
    )
    parser.add_argument(
        '--force', '-f', '--force-overwrite',
        action='store_true',
        help="Force overwrite of the historical data"
    )
    parser.add_argument(
        '--reset-data',
        action='store_true',
        help="Erase all historical intersecting with new data"
    )

    try:
        args = parser.parse_args()
    except Exception as err:
        parser.print_help()
        print(str(err), file=sys.stderr)
        sys.exit(1)

    return args

def main():
    args = parse_arguments()
    
    # if not set use local.ini
    if not (args.config_file):
        inif = "local.ini"
    else:
        inif = args.config_file
    
    init_config(inif)
    
    # init the spiner for futur use
    spinner = Spinner()

    # Custom Sedimentation process
    if args.processing == 'sedimentation':        
        Sedimentation(args.tablename,args.param,args.dataset,args.output,args.output_format,args.verbose).run()
        exit()

    # Volume process
    if args.processing == 'volume':
        print("Volume query ... Process not define!")
        exit()

    if args.processing == 'deploy':

        print("Deploy pgrastertime table %s to production ... " % args.tablename)
        spinner.start()
        SQLModel.runSQL('', args.tablename, args.processing, False,args.verbose)
        spinner.stop()
        exit()
        
    if args.processing == 'validate':

        print("Validate pgrastertime table %s ... " % args.tablename)
        SQLModel.runSQL(root, args.tablename, args.processing,True,args.verbose)
        exit()
        
    # if force, we will drop et rebuilt table
    if args.force:
        SQLModel.setPgrastertimeTableStructure(args.tablename)
        SQLModel.setMetadataeTableStructure(args.tablename)
    
    # 1. Load Processing Class
    # TODO: Replace this by a factory
    if args.processing == 'load':
    
        # 2. Load file with reader options
        # TODO: Replace this by a factory
        reader = RasterReader(args.reader, args.tablename, True ,args.force)
        
        process_cls = LoadRaster(reader)
        # 3. Execute process
        # TODO: Handle dry run, force overwrite and reset-data
        process_cls.run()
        
        # Finaly, user create some post process SQL to run over loaded table
        # User can have multiple SQL file to run       
        if self.sqlfiles is not None:
            print("Post process SQL file: " + self.sqlfiles)
            PostprocSQL(args.sqlfiles,args.tablename).execute()
        
    elif args.processing == 'xml':
    
        # all XML object refer to 4 raster files that we 
        # need to load in database.  If it's a directory;
        error_list = []
        ns=nb=er=0
        if os.path.isdir(args.reader):
        
            # we will inform each loop how many file left ...
            xmlCounter = len(glob.glob1(args.reader,"*.xml")) 
               
            for file in os.listdir(args.reader):
                if (os.path.splitext(file)[-1].lower() == '.xml'):
                    nb += 1
                    print ("\n Process file %d of %d ..." % (nb,xmlCounter))
                    if (XMLRastersObject(os.path.join(args.reader, file),
                                     args.tablename,
                                     args.force,
                                     args.sqlfiles,
                                     args.verbose).importRasters() != "SUCCESS"):
                        er += 1
                        error_list.append(os.path.join(args.reader, file))
                    else:
                        ns += 1

            # Print result of process
            print ("\n Convert %d files of %d" % (ns,nb))
            if len(error_list):
                print ("Invalid or corrupt files list:")
                print ("\n".join(error_list))


        elif os.path.isfile(args.reader):
            # user specify a file instead of a folder to process
            # Import all raster files link to the XML object
            #XMLRastersObject(args.reader,
            #                 args.tablename,
            #                 args.force,
            #                 args.sqlfiles,
            #                 args.verbose).importRasters()
            
            XML2RastersResampling(args.reader,
                             args.tablename,
                             args.force,
                             args.sqlfiles,
                             args.verbose).importRasters()                 
                             
                             