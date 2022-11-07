#!/bin/bash

# Program wyszukuje proces selenium. Jeśli jest uruchomiony 
# to pobiera logi apilkacji i czeka na właściwy wpis.
# Po zanlezieniu odpowiedniego wpisu zatrzymuje selenium
# a następnie uruchamia ponownie po minucie
# Skrypt umieścić w folderze z pozostałymi skryptami

# setup
szukaj_tego="java"
plik_logow="${HOME}/ano_machine/logs/ano_machine-tests.log"
logi_czyszczenia="${HOME}/logi_czyszczenia.txt"
folder_skryptow="${HOME}/skrypty_testowe"

# Sprawdz czy selenium chodzi
selenium=$(pgrep "${szukaj_tego}" | grep -v grep)
if [[ -z "${selenium}" ]]
then
	echo "$(date) test nie jest uruchomiony" >> "${logi_czyszczenia}"
	exit 0
fi

# Czekaj na odpowiedni moment
odpowiedni_moment=""
watchdog=0
while [[ -z "${odpowiedni_moment}" && ${watchdog} -lt 3600 ]]
do
	sleep 0.2
	(( watchdog+=1 ))
	odpowiedni_moment=$(tail -n 8 "${plik_logow}" | grep "process completed")
done

# Wyjście jeśli sie nie udało
if [[ -z "${odpowiedni_moment}" ]] 
then
	exit 1
fi

# Zabijanie selenium
notify-send "Przerwa techniczna."
echo "$(date) zatrzymuje selenium" >> "${logi_czyszczenia}"
kill $(pgrep chrome)
kill $(pgrep java)

# Przerwa na kawę
notify-send "Przerwa techniczna"
sleep 20
notify-send "Przerwa techniczna"
sleep 40


# Start selenium w nowym terminalu
echo "$(date) uruchamiam selenium" >> "${logi_czyszczenia}"
gnome-terminal -- bash -c "${folder_skryptow}/czyszczenie_subscripts/zabij_terminale.sh; ${folder_skryptow}/start_selenium_v2.sh; exec bash"

exit 0
