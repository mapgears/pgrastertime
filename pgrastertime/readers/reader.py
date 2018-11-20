# -*- coding: utf-8 -*-


class Reader:

    # Iso format (YYYY-MM-DD HH:MM:SS) in GMT
    date = None

    # In cm
    resolution = None

    def __init__(self, date, resolution):
        self.date = date
        self.resolution = resolution

    def get_file(self, resolution=None):
        raise(Exception('Not implemented'))
