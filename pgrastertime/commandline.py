"""
Loads raster data in a PGRaster data that will be used for analytics.
New raster will be added to the history based on a time component.
"""

import argparse
import os
import sys

from pgrastertime import init_config
from pgrastertime.readers import RasterReader
from pgrastertime.processes import LoadRaster
from pgrastertime.processes import XMLRastersObject

root = os.path.dirname(os.path.dirname(__file__))


def parse_arguments():
    parser = argparse.ArgumentParser(description=__doc__)

    parser.add_argument(
        'config_file',
        nargs='?', help=argparse.SUPPRESS,
        default=os.path.join(root, 'local.ini'),
    )

    parser.add_argument(
        '--config_file', '--config', '-c', dest='config_file',
        help='.ini configuration file', metavar='config_file',
    )

    parser.add_argument(
        'reader',
        help='Reader driver options',
    )
    parser.add_argument(
        'processing',
        help='Processing option',
    )
    parser.add_argument(
        '--tablename', '-t',
        help="Target raster table name in Postgresql"
    )
    parser.add_argument(
        '--sql', '-s',
        help="Custome postprocess SQL"
    )
    parser.add_argument(
        '--verbose', '-v',
        action='count', default=0,
        help="Verbose"
    )
    parser.add_argument(
        '--dry-run', '-d', '-n',
        action='store_true',
        help="Perform a trial run with no changes made"
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


    # 1. Load Processing Class
    # TODO: Replace this by a factory
    if args.processing == 'load':
    
        # 2. Load file with reader options
        # TODO: Replace this by a factory
        reader = RasterReader(args.reader,args.tablename)
        
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
                    XMLRastersObject(os.path.join(args.reader, file),args.tablename).importRasters()
            

        elif os.path.isfile(args.reader):
            # user specify a file instead of a folder to process
            # Import all raster files link to the XML object
            XMLRastersObject(args.reader,args.tablename).importRasters()
    
    # Finaly, user create some post process SQL to run over loaded table        
    elif args.sql is not None:
        print("sql") 
        # User can have multiple SQL file to run
        
            
    else:
        raise(Exception('Unknown process: {}'.format(args.processing)))
