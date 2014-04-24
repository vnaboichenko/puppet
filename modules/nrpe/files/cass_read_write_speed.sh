#! /bin/bash

#This Plug-in monitors Cassandra number of read and write operations in a given time period, i.e. Read operations per second / write Operations per second.
#it fetches WriteOperations or ReadOperations from Nagios JMX plugin and stores the values with timestamp in a log file at /tmp directory, and parses this log file to create the Read/write per second value.

####Sample Log entries###
#cat /tmp/Cass_ReadOperations.log
#1323353650=JMX CRITICAL ReadOperations=0
#1323353710=JMX CRITICAL ReadOperations=120

#so the Read per second would be (120-0)/(1323353710-1323353650) i.e 2 per Second.



# This take three parameters as input 1) Option i.e. Read operations or  write Operations and Warning and Critical Values.

# Author - Juned Memon



#########THIS part is for Nagios ################################
PROGNAME=`/usr/bin/basename $0`
PROGPATH=`echo $0 | sed -e 's,[\\/][^\\/][^\\/]*$,,'`
REVISION=`echo '$Revision: 1749 $' | sed -e 's/[^0-9.]//g'`
#. $PROGPATH/utils.sh
. /usr/lib/nagios/plugins/utils.sh

######################################################################

#Function to print Usage
function usage
{
usage1="Usage: $0 -o <Option> [-w <WARN>] [-c <CRIT>]"
usage2="<Option> is which option to perform (ReadOperations | WriteOperations), Default is ReadOperations "
usage3="<WARN> is Rate/second for  WARNing state   Default is 5."
usage4="<CRIT> is Rate/second for Critical  state  Default is 10."
echo $usage1
#echo""
echo $usage2
#echo""
echo "$usage3"
#echo""
echo "$usage4"

exit $STATE_UNKNOWN
}


WARN=5
CRIT=10
OPT="ReadOperations"
#####################################################################
# get parameter values in Variables

while test -n "$1"; do
    case "$1" in
        -c )
            CRIT=$2
            shift
            ;;
        -w )
            WARN=$2
            shift
            ;;
       -o )
            OPT=$2
            shift
            ;;

        -h)
            usage
            ;;
        *)
            echo "Unknown argument: $1"
            usage
            ;;
    esac
    shift
done

#####################################################################

DATE=$(date +%s)
FILE="/tmp/Cass_$OPT.log"
READ=$(/usr/lib/nagios/plugins/check_jmx -U service:jmx:rmi:///jndi/rmi://127.0.0.1:7199/jmxrmi -O org.apache.cassandra.db:type=StorageProxy -A $OPT)

echo "$DATE=$READ" >> $FILE
#echo "write_cassandra.log file updated"

SPEED=$(tail -n 2 $FILE |  awk 'BEGIN {FS="=" } {A[NR-1] = $1; B[NR-1] = $3} END { print (B[1] -B[0]) / (A[1] - A[0])}')
SPEED=$(echo $SPEED | awk '{printf "%.0f",$1}')
echo "Cassandra $OPT are $SPEED per second | $OPT=$SPEED "

#if CRIT > SPEED >WARN then WARNing
if [ $SPEED -ge $WARN ]; then
if [ $SPEED -lt $CRIT ]; then
exitstatus=$STATE_WARNING
exit $exitstatus
fi
fi
# SPEED>CRIT then CRITical
if [ $SPEED -ge $CRIT ]; then
exitstatus=$STATE_CRITICAL
exit $exitstatus
fi

# 0<=SPEED <WARN
if [ $SPEED -le $WARN ]; then
exitstatus=$STATE_OK
exit $exitstatus
fi

