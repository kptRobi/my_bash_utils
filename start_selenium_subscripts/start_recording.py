#!/usr/bin/env python
# -*- coding: utf-8 -*-

# 1 - Nie można połączyć się z OBS
# 2 - Nie udało się uruchomić nagrywania
import sys
import time
import logging
import contextlib
logging.basicConfig(level=logging.ERROR)
sys.path.append('./')

#Elektordi/obs-websocket-py
from obswebsocket import obsws, requests, exceptions

host = "localhost"
port = 4444
password = "dtiw"
ws = obsws(host, port, password)

#Próba połączenia z OBS
try:
	ws.connect()
except ConnectionRefusedError:
	pass
except exceptions.ConnectionFailure:
	print("")
	print("                      !BŁĄD!")
	print("------------------------------------------------")
	print("        Nie można połączyć z OBS Studio!")
	print("Sprawdź czy program OBS Studio jest uruchomiony")
	print("-------------------------------------------------")
	print("")
	exit(1)

#Próba rozpoczęcia nagrywania
try:
	recording_status = ws.call(requests.GetRecordingStatus())
	is_recording = recording_status.getIsRecording()
	if(not is_recording):
		ws.call(requests.StartRecording())
	else:
		ws.call(requests.StopRecording())
		#print("Kończenie poprzedniego nagrania")
		time.sleep(1.5)
		ws.call(requests.StartRecording())
	for i in range(10):
		recording_status = ws.call(requests.GetRecordingStatus())
		is_recording = recording_status.getIsRecording()
		if(not is_recording):
			print("Trwa uruchamianie nagrywania")
			time.sleep(1.5)
		else:
			#print("Uruchomiono nagrywanie")
			break
	if(not is_recording):
		exit(2)

except KeyboardInterrupt:
    pass

ws.disconnect()
exit(0)
