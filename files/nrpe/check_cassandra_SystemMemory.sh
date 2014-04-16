#!/bin/bash






CASSANDRA_MEMORY_PERCENTS=`ps -auxfw |  grep CassandraDaemon  | grep java | awk '{ print $4 }' 2>/dev/null`
#SYSTEM_MEM_TOTAL_KB=`cat /proc/meminfo  | grep MemTotal | awk '{ print $2 }'`
#CASSANDRA_MEMORY_USAGE=`echo ${CASSANDRA_MEMORY_PERCENTS}*${SYSTEM_MEM_TOTAL_KB}/100 | bc`



while getopts ":w:c:" OPTION; do
    case "$OPTION" in
        c)  CRITICAL_LEVEL="$OPTARG" ;;
        w)  WARNING_LEVEL="$OPTARG" ;;
    esac
done



if [ -z ${WARNING_LEVEL} ]
then
    echo "Undefined warning level"
    exit 3
fi

if [ -z ${CRITICAL_LEVEL} ]
then
    echo "Undefined critical level"
    exit 3
fi


if [ ${WARNING_LEVEL} -eq ${WARNING_LEVEL} 2>/dev/null ]; 
then
    echo ${WARNING_LEVEL}" is a number" >/dev/null
    WARNING_LEVEL_00=${WARNING_LEVEL}"00"
else
    echo "Undefined warning level. Should be integer"
    exit 3
fi

if [ ${CRITICAL_LEVEL} -eq ${CRITICAL_LEVEL} 2>/dev/null ]; 
then
    echo ${CRITICAL_LEVEL}" is a number" >/dev/null
    CRITICAL_LEVEL_00=${CRITICAL_LEVEL}"00"
else
    echo "Undefined warning level"
    exit 3
fi


if [ ${CRITICAL_LEVEL} -lt ${WARNING_LEVEL} 2>/dev/null ]; 
then
    echo "warning Level should be less than critical level"
    exit 3
fi


if [ ${CRITICAL_LEVEL} -gt 100 2>/dev/null ]; 
then
    echo "Critical Level should be less than  100%"
    exit 3
fi

if [ ${WARNING_LEVEL} -gt 100 2>/dev/null ]; 
then
    echo "WARNING Level should be less than  100%"
    exit 3
fi










CASSANDRA_MEMORY_TEST=`echo ${CASSANDRA_MEMORY_PERCENTS}*100 | bc 2>/dev/null | awk -F"." '{ print $1 }' 2>/dev/null`


if test -n "${CASSANDRA_MEMORY_TEST}"  2>/dev/null 
then
    echo ${CASSANDRA_MEMORY_TEST}" is a number" >/dev/null
else
    # 'label'=value[UOM];[warn];[crit];[min];[max]
    echo "CRITICAL: Can't check cassandra  (Cassandra is down?)| CassandraMemoryUsage=0%;"${WARNING_LEVEL}";"${CRITICAL_LEVEL}
    exit 2
fi


if [ ${CASSANDRA_MEMORY_TEST} -eq ${CASSANDRA_MEMORY_TEST} 2>/dev/null ]; 
then
    echo ${CASSANDRA_MEMORY_PERCENTS}" is a number" >/dev/null
else
    # 'label'=value[UOM];[warn];[crit];[min];[max]
    echo "CRITICAL: Can't check cassandra  (Cassandra is down?)| CassandraMemoryUsage=0%;"${WARNING_LEVEL}";"${CRITICAL_LEVEL}
    exit 2
fi





if [ ${CASSANDRA_MEMORY_TEST} -gt ${WARNING_LEVEL_00} ]
then
    if [ ${CASSANDRA_MEMORY_TEST} -gt ${CRITICAL_LEVEL_00} ]
    then
    # Critical
	echo "CRITICAL - Cassandra use " ${CASSANDRA_MEMORY_PERCENTS}"|CassandraMemoryUsage="${CASSANDRA_MEMORY_PERCENTS}"%;"${WARNING_LEVEL}";"${CRITICAL_LEVEL}
	exit 2
    fi
    echo "WARNING - Cassandra use " ${CASSANDRA_MEMORY_PERCENTS}"|CassandraMemoryUsage="${CASSANDRA_MEMORY_PERCENTS}"%;"${WARNING_LEVEL}";"${CRITICAL_LEVEL}
    exit 1
fi

# OK
echo "OK - Cassandra use "${CASSANDRA_MEMORY_PERCENTS}"% |CassandraMemoryUsage="${CASSANDRA_MEMORY_PERCENTS}"%;"${WARNING_LEVEL}";"${CRITICAL_LEVEL}
exit 0