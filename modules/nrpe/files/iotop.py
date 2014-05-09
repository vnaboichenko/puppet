#! /usr/bin/env python

import re
import sys
import getopt
import subprocess

# converts speed to Bytes
def convert(speed, units):
    if units == "B":
        return speed
    elif units == "K":
        return speed * 1024
    elif units == "M":
        return speed * 1024 * 1024


try:
    # params with default names in nagios
    # -w : warning level, in percents
    # -c : critical level, in percents
    # -repeats : repeats count
    opts, args = getopt.getopt(sys.argv[1:], "c:w:r:", [])

    # default values
    host = None
    warning_level = 10
    critical_level = 5
    repeats_count = 15

    for opt, arg in opts:
        if opt in ("-c"):
            critical_level = int(arg)
        elif opt in ("-w"):
            warning_level = int(arg)
        elif opt in ("-r"):
            repeats_count = int(arg)

    results_read = []
    results_write = []

    for iteration in range(repeats_count):
        process = subprocess.Popen('iotop -b -n 1', shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        output, errors = process.communicate()
        process.wait()

        match = re.search('Total DISK READ: (.*?) (\w+?)/s \\| Total DISK WRITE: (.*?) (\w+?)/s', output)

        speed_read = float(match.group(1))
        units_read = match.group(2)
        speed_write = float(match.group(3))
        units_write = match.group(4)

        # now i need to convert all to bits/s
        results_read.append(convert(speed_read, units_read))
        results_write.append(convert(speed_write, units_write))

    average_speed_read = int(round(float(sum(results_read) / len(results_read))))
    average_speed_write = int(round(float(sum(results_write)) / len(results_write)))

except:
    print "Unknown: " + str(sys.exc_info()[1])
    exit(3)

# default return values
return_code = 0
status_message = "OK"

if average_speed_read > warning_level or average_speed_write > warning_level:
    if average_speed_read > critical_level or average_speed_write > critical_level:
        status_message="Critical"
        return_code = 2
    else:
        status_message = "Warning"
        return_code = 1

print status_message + ", disk read: "+str(average_speed_read)+"B/s, disk write: "+str(average_speed_write)+"B/s |read="+str(average_speed_read)+"B/s;;;;write="+str(average_speed_write)+"B/s;;;;"
exit(return_code)

