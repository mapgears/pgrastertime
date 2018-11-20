# -*- coding: utf-8 -*-

from subprocess import check_output

from pgrastertime.data.sqla import DBSession
from pgrastertime import CONFIG
from pgrastertime.processes.process import Process


class LoadRaster(Process):

    def run(self):
        resolutions = CONFIG['app:main'].get('output.resolutions').split(',')
        for resolution in resolutions:
            filename = self.reader.get_file(resolution=resolution)

            if not filename:
                continue

            command = [
                "raster2pgsql",
                "-a",
                "-f", "raster",
                "-t", "2000x2000",
                filename,
                "pgrastertime"
            ]
            sql = check_output(command).decode()

            # Add manadatory column in INSERT statement
            sql = sql.replace(
                '("raster") VALUES (',
                '("tile_id", "resolution", "sys_period", "raster") '
                'VALUES ({}, {}, tstzrange(\'{}\', NULL), '.format(
                    self.reader.id, resolution, self.reader.date
                )
            )

            DBSession().execute(sql)
