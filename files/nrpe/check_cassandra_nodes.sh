#!/bin/bash



NODETOOL="/opt/cassandra/bin/nodetool ring"

ACTIVE_NODES=`${NODETOOL}  | grep -v "Token"  | grep -v "Note: Ownership information does not include topology, please specify a keyspace" | grep "Up"| wc -l`
# extra line

if [ ${ACTIVE_NODES} -eq ${ACTIVE_NODES} 2>/dev/null ]; 
then
    echo ${ACTIVE_NODES}" is a number" >/dev/null
else
    # 'label'=value[UOM];[warn];[crit];[min];[max]
    echo "CRITICAL: Can't check cassandra | Nodes=0;"
    exit 2
fi


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
else
    echo "Undefined warning level. Should be integer"
    exit 3
fi

if [ ${CRITICAL_LEVEL} -eq ${CRITICAL_LEVEL} 2>/dev/null ]; 
then
    echo ${CRITICAL_LEVEL}" is a number" >/dev/null
else
    echo "Undefined warning level"
    exit 3
fi


#echo ${CRITICAL_LEVEL}" -lt "${WARNING_LEVEL}
if [ ${CRITICAL_LEVEL} -lt ${WARNING_LEVEL} 2>/dev/null ]; 
then
    echo "warning Level should be less than critical level (-w "${WARNING_LEVEL} "and -c " ${CRITICAL_LEVEL}")"
    exit 3
fi



if [ ${ACTIVE_NODES} -lt ${WARNING_LEVEL} ]
then
    if [ ${ACTIVE_NODES} -lt ${CRITICAL_LEVEL} ]
    then
    # Critical
	echo "CRITICAL - " ${ACTIVE_NODES}" node(s) is(are) up and running (Critical level is "${CRITICAL_LEVEL}")|Nodes="${ACTIVE_NODES}";"${WARNING_LEVEL}";"${CRITICAL_LEVEL}
	exit 2
    fi
    echo "WARNING - " ${ACTIVE_NODES}" node(s) is(are) up and running (Warning level is "${WARNING_LEVEL}")|Nodes="${ACTIVE_NODES}";"${WARNING_LEVEL}";"${CRITICAL_LEVEL}
    exit 1
fi

# OK
echo "OK - "${ACTIVE_NODES}" nodes are up and running |Nodes="${ACTIVE_NODES}";"${WARNING_LEVEL}";"${CRITICAL_LEVEL}
exit 0