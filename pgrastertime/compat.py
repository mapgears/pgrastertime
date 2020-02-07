try:
    from os import fspath
except ImportError:
    fspath = str
