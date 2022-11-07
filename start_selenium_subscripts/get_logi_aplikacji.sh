#!/bin/bash

# 1 - Brak podanego argumentu
# 2 - Brak połączenia z maszyną
# INNE - Nie udało się pobrać logów, błąd sshpass

if [ $# -eq 0 ]
then
    exit 1
fi

if ! ping -c 1 ${IP} 
then
    exit 2
fi

sshpass -p "${user_PASSWD}" scp user@$IP:/var/log/ano_machine/ano_machine.log "${1}"
RESULT=$?
if [ $RESULT != 0 ]
then
    exit 0
else
    exit 3
fi
