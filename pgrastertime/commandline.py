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

    # 1. Load file with reader options
    # TODO: Replace this by a factory
    reader = RasterReader(args.reader)

    # 2. Load Processing Class
    # TODO: Replace this by a factory
    if args.processing == 'load':
        process_cls = LoadRaster(reader)
    else:
        raise(Exception('Unknown process: {}'.format(args.processing)))

    # 3. Execute process
    # TODO: Handle dry run, force overwrite and reset-data
    process_cls.run()
