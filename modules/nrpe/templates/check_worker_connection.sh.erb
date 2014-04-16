#!/bin/bash


worker_node=`/usr/bin/nslookup worker | grep -v "#" | grep "Address" | awk '{print $2}'`


connection=`/usr/bin/curl --silent http://guest:guest@127.0.0.1:15672/api/connections  | python -m json.tool | grep -v "peer" | grep $worker_node`

if [ $? != 0 ]
    then
		status="Worker connection with rabbit is Warning | connection=0"
		echo $status
		exit 1
	else 
		status="Worker connection with rabbit is OK | connection=1"
		echo $status
		exit 0
fi

