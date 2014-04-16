#!/bin/bash

#default alert varibles
warning="100"
critical="200"
queue_name="rpc"

while getopts "w:c:q:" Option
do
  case $Option in
	w)
		warning=$OPTARG
		;;
	c)
		critical=$OPTARG
		;;
	q)
		queue_name=$OPTARG
		;;
	*)
	echo "Usage: $0 -q 'queue name' -w 'warning level' -c 'critical level'"
	exit 3
	;;
  esac
done

#plugin for statlogs queue

if [ "$queue_name" == "StatLogs" ]
then
	queue=`curl --silent http://guest:guest@127.0.0.1:15672/api/queues/ | python -m json.tool | grep '"messages_ready"' | awk -F',' '{print $1}' | awk '{print $2}' | awk '(NR==1)'`
fi

if [ "$queue_name" == "rpc" ]
then
	queue=`curl --silent http://guest:guest@127.0.0.1:15672/api/queues/ | python -m json.tool | grep '"messages_ready"' | awk -F',' '{print $1}' | awk '{print $2}' | awk '(NR==2)'`
fi


if [ "$queue" -gt "$warning" ]
    then
		status="$queue_name=${queue} is Warning | queue=${queue}"
		echo $status
		exit 1
fi

if [ "$queue" -gt "$critical" ]
    then
		status="$queue_name=${queue} is Critical | queue=${queue}"
		echo $status
		exit 2
fi


if [ "$queue" -lt "$warning" ] || [ "$queue" -lt "$critical" ]
    then
		status="$queue_name=${queue} is OK | queue=${queue}"
		echo $status
		exit 0
fi

