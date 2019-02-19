#!/usr/bin/env python
import time
from pgrastertime.commandline import main

if __name__ == '__main__':
    start_time = time.time()
    main()
    print(" Execution took %.1f minutes to process" % float((time.time() - start_time)/60))
