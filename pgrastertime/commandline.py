"""
Loads raster data in Postgresql database with pgRaster extension, that can be used for complex analytics.
Temporal raster file will be added to a master history table based on a time component.
"""

import argparse, os, sys, time

from pgrastertime import init_config
from pgrastertime.readers import RasterReader
from pgrastertime.processes import LoadRaster
from pgrastertime.processes import XMLRastersObject
from pgrastertime.processes import PostprocSQL
from pgrastertime.data.models import SQLModel

from pgrastertime.processes.spinner import Spinner

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
        '--input-dataset', '-i', default='', 
        help="Input Dataset used as an option for processing (shapefiles or geojson)"
    )
    parser.add_argument(
        '--reader', '-r', default='',
        help='Reader driver options',
    )
    parser.add_argument(
        '--processing', '-p', default='',  choices=['load', 'xml', 'deploy', 'volume', 'sedimentation'],
        help='Processing option',
    )
    parser.add_argument(
        '--output', '-O', default='', 
        help='Output shapefiles'
    )
    parser.add_argument(
        '--option', '-oi', nargs='?', action='append',
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
    init_config(args.config_file)
    spinner = Spinner()

    # Sedimentation process
    if args.processing == 'sedimentation':
        print("Sedimentation query ... Process not define!")
        exit()
        
    # Volume process
    if args.processing == 'volume':
        print("Volume query ... Process not define!")
        exit()

    # Deploy process
    if args.processing == 'deploy':
        
        print("Deploy pgrastertime table %s to production ... " % args.tablename)
        spinner.start()
        SQLModel.deployPgrastertimeTable(root,args.tablename)
        spinner.stop()
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
        reader = RasterReader(args.reader,args.tablename,args.force)
        
        process_cls = LoadRaster(reader)
        # 3. Execute process
        # TODO: Handle dry run, force overwrite and reset-data
        process_cls.run()
        
    elif args.processing == 'xml':
    
        # all XML object refer to 4 raster files that we 
        # need to load in database.  If it's a directory;
        if os.path.isdir(args.reader):    
            for file in os.listdir(args.reader):
                if (os.path.splitext(file)[-1].lower()== '.xml'):
                    XMLRastersObject(os.path.join(args.reader, file),args.tablename,args.force).importRasters()
            

        elif os.path.isfile(args.reader):
            # user specify a file instead of a folder to process
            # Import all raster files link to the XML object
            XMLRastersObject(args.reader,args.tablename,args.force).importRasters()
            
    # Finaly, user create some post process SQL to run over loaded table
    # User can have multiple SQL file to run       
    if args.sqlfiles is not None:
        print("Post process SQL file: " + args.sqlfiles)
        spinner = Spinner()
        spinner.start()
        PostprocSQL(args.sqlfiles,args.tablename).execute()
        spinner.stop()
        
