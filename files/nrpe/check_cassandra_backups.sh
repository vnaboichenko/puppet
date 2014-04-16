#!/bin/bash 

local_addr=`ifconfig | grep "inet addr:" | awk '(NR==1)' | awk -F":" '{print $2}' | awk '{print $1}'`
backup_dir="/home/cassandra/cassandra_backup_test"
current_date=`date +%F`
day_ago=`date +%F -d'now -1 day'`
two_day_ago=`date +%F -d'now -2 day'`

mount_dir="/home/cassandra/s3storage_test"


find $backup_dir -type d >> /dev/null

if [ $? != 0 ]
    then
	echo "$backup_dir doesnt exit"
	exit 2
fi

find $mount_dir -type d >> /dev/null


if [ $? != 0 ]
    then
	echo "${mount_dir} doesnt exit"
	exit 2
fi

#backups usualy runs at 9:00

if [ `date +%H` -ge "10" ]
then
	echo new_day
	    size=`ls -lah ${mount_dir}/backup"${current_date}""ip_$local_addr".tar.bz2 | awk '{print $5}'`
	    if [ `stat ${mount_dir}/backup"${current_date}""ip_$local_addr".tar.bz2 -c %s` -lt `stat ${mount_dir}/backup"${day_ago}""ip_$local_addr".tar.bz2 -c %s` ]
		then
			echo "Backups for ${current_date} is less than ${day_ago} | backup_size=${size}"
			exit 1
		else
			echo "Backups for ${current_date} is OK | backup_size=${size}"
			exit 0
		
	    fi
fi


if [ `date +%H` -lt "10" ]
then
	echo old_day
	    size=`ls -lah ${mount_dir}/backup"${day_ago}""ip_$local_addr".tar.bz2 | awk '{print $5}'`
	    if [ `stat ${mount_dir}/backup"${day_ago}""ip_$local_addr".tar.bz2 -c %s` -lt `stat ${mount_dir}/backup"${two_day_ago}""ip_$local_addr".tar.bz2 -c %s` ]
		then 
			echo "Backups for ${day_ago} is less than ${two_day_ago} | backup_size=${size}"
			exit 1
		else
			echo "Backups for ${day_ago} is OK | backup_size=${size}"
			exit 0
		

	    fi
fi






exit 0
