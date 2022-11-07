#!/bin/bash

# Program służy jak nakładka do uruchamiania testów selenium poleceniem ./gradlew
# Dodatkowo:
# 1. Uruchamia i zatrzymuje nagrywanie ekranu w OBS Studio
# 2. Po zatrzymaniu wycina ostatnie 60s i 5min nagrania ekranu
# 3. Pobiera logi aplikacji, selenium i output konsoli w momencie zatrzymania testu
# 3. Tworzy podfolder z datą i godziną zatrzymania w którym umieszcza wycinek nagrania i komplet logów

STORAGE_DIR=$HOME"/Zatrzymania/"
TMP_OUTPUT_FILE=$STORAGE_DIR"tmp.txt"
SELENIUM_LOGS_FILE=$HOME"/ano_machine/logs/ano_machine-tests.log"
RECORDINGS_DIR="$HOME/Nagrania/"
SCRIPTS_HOME_DIR="$HOME/skrypty_testowe/"

#kody bledow
ERR_START_REC=("NAGRYWANIE ROZPOCZĘTE" "BŁĄÐ nagrywania - Nie można połączyć się z OBS" "BŁĄÐ nagrywania - Nie udało się uruchomić nagrywania")
ERR_STOP_REC=("NAGRYWANIE ZATRZYMANE" "BŁĄÐ nagrywania - Nie można połączyć się z OBS" "BŁĄÐ nagrywania - Nie udało się zatrzymać nagrywania")
ERR_GET_LOG=("LOGI APLIKACJI POBRANE" "BŁĄÐ pobierania logów - Brak podanego argumentu" "BŁĄÐ pobierania logów - Brak połączenia z maszyną" "BŁĄÐ pobierania logów - Nie udało się pobrać logów")
ERR_GET_VIDEO=("SKOPIOWANO NAGRANIE" "BŁĄÐ pobierania nagrania - Brak podanych argumentów")

#GUI
sleep 0.2
echo .
sleep 0.1
echo ..
sleep 0.3
echo ...

#Tworzenie folderow na logi i nagrania
if [ ! -d $STORAGE_DIR ] 
then
    mkdir $STORAGE_DIR
fi
if [ ! -d $RECORDINGS_DIR ] 
then
    mkdir $RECORDINGS_DIR
fi

#Włączenie nagrywania ekranu
python3 "$SCRIPTS_HOME_DIR"start_selenium_subscripts/start_recording.py
RESULT=$?
echo ${ERR_START_REC[$RESULT]}

#Odpalenie testu z przekierowaniem do pliku .txt
if (( $RESULT==0 ))
then
    cd ~/ano_machine
	./gradlew cleanTest test --no-build-cache --info -Ddemo-ver=1 -Dbase-url=${IP} --tests "pl.noatech.ano.selenium_local.junit5.SeleniumLocalTestsJUnit5.infiniteTest" > $TMP_OUTPUT_FILE 
    cd $SCRIPTS_HOME_DIR
fi
if (( $RESULT != 0 ))
then
    exit 1
fi

#drzemka
sleep 10 

#Wyłączenie nagrywania
python3 "$SCRIPTS_HOME_DIR"start_selenium_subscripts/stop_recording.py
RESULT=$?
echo ${ERR_STOP_REC[$RESULT]}

CURRENT_DATE=$(date '+%Y-%m-%d_%H:%M:%S')
STOP_SUBDIR=$STORAGE_DIR"zatrzymanie_z_$CURRENT_DATE/"
FILE_LOGI_SELENIUM="ano_machine-tests_$CURRENT_DATE.log"
FILE_OUTPUT_KONSOLI="output_konsoli_$CURRENT_DATE.txt"
FILE_LOGI_APLIKACJI="ano_machine_$CURRENT_DATE.log"
FILE_NAGRANIE_CUT="nagranie_z_$CURRENT_DATE.mkv"
FILE_NAGRANIE_5_CUT="nagranie_5_minut_z_$CURRENT_DATE.mkv"

#drzemka
echo "--------------------"
echo "Nie dotykaj mnie, "
echo "pobieram logi...  "
echo "--------------------"
sleep 10

#wrzucanie 3 plikow z logami do jednego folderu
mkdir $STOP_SUBDIR
cp $SELENIUM_LOGS_FILE $STOP_SUBDIR$FILE_LOGI_SELENIUM
mv $TMP_OUTPUT_FILE $STOP_SUBDIR$FILE_OUTPUT_KONSOLI
"$SCRIPTS_HOME_DIR"start_selenium_subscripts/get_logi_aplikacji.sh $STOP_SUBDIR$FILE_LOGI_APLIKACJI
RESULT=$?
echo ${ERR_GET_LOG[$RESULT]}

#kopiowanie nagrania do folderu z logami
FILE_NAGRANIE_RAW=$(ls -Art1 $RECORDINGS_DIR | tail -n 1)
python3 "$SCRIPTS_HOME_DIR"start_selenium_subscripts/get_last_minute.py $RECORDINGS_DIR$FILE_NAGRANIE_RAW $STOP_SUBDIR$FILE_NAGRANIE_CUT
python3 "$SCRIPTS_HOME_DIR"start_selenium_subscripts/get_last_five_minutes.py $RECORDINGS_DIR$FILE_NAGRANIE_RAW $STOP_SUBDIR$FILE_NAGRANIE_5_CUT
RESULT=$?
echo ${ERR_GET_VIDEO[$RESULT]}
