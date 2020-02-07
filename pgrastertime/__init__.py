from configparser import ConfigParser
from pathlib import Path

from .data.sqla import init_sqla


ROOT = Path(__file__).parent.parent
CONFIG = ConfigParser()


def init_config(config_file):
    CONFIG.read(config_file)
    init_sqla(CONFIG['app:main'])
