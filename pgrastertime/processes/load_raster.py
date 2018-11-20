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
                "-f", "raster",
                "-Y",
                "-t", "2000x2000",
                "-x", "-C",
                "-I",
                "-F",
                "-M",
                filename,
                "pgrastertime"
            ]
            sql = check_output(command).decode()

            DBSession().execute(sql)
