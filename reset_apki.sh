#!/bin/bash

# Program resetuje aplikację.
# z opcją "-s" dodatkowo uruchamia test selenium po resecie.

# Upierdalanie javium i chromium
sshpass -p "${QPS_PASSWD}" ssh user@${IP} "pkill -9 java;pkill -9 chromium-browse"

sshpass -p "${QPS_PASSWD}" ssh user@${IP} "./autostart.sh \&;"

# Oczekiwanie na wstanie aplikacji
RPI_RESPONSE=""
for((i=0; i<10; i++))
do
	sleep 5
	RPI_RESPONSE=""
	RPI_RESPONSE=$(curl --connect-timeout 2 -s -X GET ${IP}:${PORT})
	if [[ $RPI_RESPONSE == "" ]]
	then
		echo "Nie udało się uruchomić aplikacji"
	else
		echo "Gotowe!"	
		break
	fi
done

# Opcjonalne uruchomienie testu selenium
while getopts 's' OPTION
do
case "$OPTION" in
	s)
	echo "START SELENIUM"
	~/skrypty_testowe/start_selenium.sh
	;;
	
	?)
	echo "nope"
	exit 1
	;;
esac
done

