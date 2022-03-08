#!/bin/bash
#bdereims@gmail.com

#. ./env

DB=web.txt
USERNAME=root
PASSWORD='VMware1!'
DATABASE=nginx

cp /dev/null $DB 

echo "generating..."

while true; do
	for LINE in {1..1}
	do
		NAME=$( ./petname.sh )
		DATE=$( date +%c )
		UUID=$( cat /proc/sys/kernel/random/uuid )
		printf "${LINE}-${UUID}-${NAME}\t${DATE}\n" > ${DB} 
		cat ${DB}
	done

	echo "loading..."

	mysqlimport -u ${USERNAME} -p${PASSWORD} --local ${DATABASE} ${DB} 

	sleep 5 
done

rm ${DB}
