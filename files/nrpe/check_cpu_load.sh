#!/bin/bash


# just wrapper

while getopts ":w:c:h:" OPTION; do
    case "$OPTION" in
        c)  CRITICAL_LEVEL="$OPTARG" ;;
        w)  WARNING_LEVEL="$OPTARG" ;;
    h)  HOST_NAME="$OPTARG" ;;
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

STATUS=0
CPU_NUM=0
RESULT=""
PERFDATA=""
TMP=`mktemp`
/usr/bin/snmpwalk -On -v2c -c MoNiToR ${HOST_NAME} .1.3.6.1.2.1.25.3.3.1.2 > ${TMP}
while read  L 
do
    CPU_LOAD=`echo $L | awk -F":" '{ print $2 }'| sed s/" "/""/g` 
#    echo "CPU_LOAD: CPU"${CPU_NUM}" "$CPU_LOAD

    # Check results
    if [ ${CPU_LOAD} -eq ${CPU_LOAD} 2>/dev/null ];
    then
#	echo "CPU LOAD is int, looks OK"
    RESULT=`echo ${RESULT} "CPU"${CPU_NUM}" LOAD is "${CPU_LOAD}`
    PERFDATA=`echo ${PERFDATA}" CPU"${CPU_NUM}"="${CPU_LOAD}`
#	echo ${RESULT}
    else
        CPU_LOAD="Undefined"
    echo "Undefined status"
    STATUS=3
    exit 3

    

fi



if [ ${STATUS} -lt 2 ]
    then
    if [ ${CPU_LOAD} -gt ${WARNING_LEVEL} ]
    then
    if [ ${CPU_LOAD} -gt ${CRITICAL_LEVEL} ]
        then
    # Critical
        STATUS=2
	    PREFIX="CRITICAL - "
        fi
    STATUS=1
        PREFIX="WARNING - "
    else
    STATUS=0
        PREFIX="OK - "
    fi
fi




let CPU_NUM=CPU_NUM+1
done < ${TMP}
rm -f ${TMP}

echo ${PREFIX} ${RESULT}" | "${PERFDATA}
exit ${STATUS}



