# -*- coding: utf-8 -*-
from collections import ChainMap
import os
from urllib.parse import urlparse

from pgrastertime import CONFIG


class Process:

    def __init__(self, reader):
        self.reader = reader

    def run(self):
        raise NotImplementedError


class PgProcess:
    def get_pg_environ(self):
        url = urlparse(CONFIG['app:main'].get('sqlalchemy.url'))
        return ChainMap(
            {
                'PGHOST': url.hostname,
                'PGPORT': str(url.port),
                'PGDATABASE': url.path[1:],
                'PGPASSWORD': url.password,
                'PGUSER': url.username,
            },
            os.environ
        )
