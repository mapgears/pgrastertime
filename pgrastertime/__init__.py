
from configparser import ConfigParser
from .data.sqla import init_sqla

CONFIG = ConfigParser()


def init_config(config_file):
    CONFIG.read(config_file)
    print("tot:" + config_file)
    #init_sqla(CONFIG['app:main'])
