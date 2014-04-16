#!/bin/bash


file_location="/tmp/StatLogs.log"

before=`cat $file_location | grep before | awk '{print $2}'`
after=`cat $file_location | grep after | awk '{print $2}'`


if [ "$after" == "" ]
    then 
    echo "Statistics Calculation in the progress | status=1"
    exit 0
fi

if [ "$after" -eq "$before" ]
    then 
    echo "Statlogs before equal after recalculate: $after = $before | status=1"
    exit 0
fi



if [ "$after" -le "$before" ]
    then 
    echo "Was recalculated $before Statlogs | status=1"
    exit 0
fi

if [ "$after" -gt "$before" ]
    then 
    echo "Statlogs after Calculation larger than before | status=0"
    exit 1
fi

