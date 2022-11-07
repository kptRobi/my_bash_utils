#!/bin/bash

# Program usuwa bazę danych paczek i resetuje RPI

CMD="rm ${DB_PATH}/* && echo 'Paczki usunięte - reset raspberry' && sudo reboot"

if ping -c 1 ${IP}
then
    RESPONSE=$(sshpass -p "${QPS_PASSWD}" ssh user@${IP} ${CMD})
else
read -r -d '' RESPONSE << EOF
----------------------------------------zz
        
                !!!!!!
        Brak połączenia z maszyną

----------------------------------------
EOF
fi

echo "$RESPONSE"