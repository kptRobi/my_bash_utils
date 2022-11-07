#!/bin/bash

# Program zamyka wszystkie otwarte interaktywne
# terminale (/dev/pts/) poza tym w którym
# został wywołany.

terminale=$(ls /dev/pts | grep "[0-9]*")
terminale_array=($terminale)
ten_rerminal=$(tty | grep -o "[0-9]*")
terminale_array=(${terminale_array[@]/$ten_rerminal/})

for elem in "${terminale_array[@]}"
do
    pkill -SIGHUP -t pts/"${elem}"
done
exit 0