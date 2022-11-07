BIBLIOTEKI I INNE:
- Python 3: moviepy, obswebsocket
- Linux: ffmpeg, sshpass, OBS Studio

SETUP:
- Ustawić aliasy do główynch skryptów
- Wrzucić wszystko do folderu ~/skrypty_testowe/
- Ustawić gniazdko w OBSie na localhost:4444 hasło: dtiw
- Ustawić w OBSie folder zapisywania nagrań na ~/Nagrania/
- Ustawić w OBSie format na .mkv
- Ustawić w OBSie nazwy plików bez spacji
- Skonfigurować w OBSie źródło na nagrywanie całego ekranu.
- Nadać uprawnienia do wykonywania wszystkich skryptów
- Dodać do crona wpis ze skryptem czyszczenie_ramu.sh i zmiennymi środowkiskowymi HOME, PATH i SHELL 
- Ustawić zmienną środowiskową QPS_PASSWD na hasło dla użytkownika user

ALIASY:
Do pliku ~/.bashrc dodać następujące linie:
alias start-sel='~/skrypty_testowe/start_selenium.sh'
alias reset-app='~/skrypty_testowe/reset_apki.sh'
alias reset-app-s='~/skrypty_testowe/reset_apki.sh -s'
alias delete-paczki='~/skrypty_testowe/deletePaczki.sh'

HOW TO USE:
Uruchomić program OBS Studio
W terminalu używać poleceń:

start-sel 
Uruchamia test selenium

reset-app
Resetuje aplikację

reset-app-s
Resetuje aplikację i uruchamia test selenium

delete-paczki
Usuwa wszystkie paczki z maszyny
