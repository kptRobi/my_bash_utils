#!/usr/bin/env python
# -*- coding: utf-8 -*-

# 1 - Nie można połączyć się z OBS

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
	print("ConnectionRefusedError")
except exceptions.ConnectionFailure:
	print("")
	print("                      !BŁĄD!")
	print("------------------------------------------------")
	print("        Nie można połączyć z OBS Studio!")
	print("				  Coś jest nie teges")
	print("-------------------------------------------------")
	print("")
	exit(1)

#Próba rozpoczęcia nagrywania
try:
	recording_status = ws.call(requests.GetRecordingStatus())
	is_recording = recording_status.getIsRecording()
	if(is_recording):
		ws.call(requests.StopRecording())
		#print("Kończenie nagrywania")
	else:
		print("Nagrywanie nie było uruchomione :(")
	for i in range(10):
		recording_status = ws.call(requests.GetRecordingStatus())
		is_recording = recording_status.getIsRecording()
		if(is_recording):
			print("Trwa kończenie nagrywania")
			time.sleep(1.5)
		else:
			#print("Pomyślnie zakończono nagrywanie")
			break

except KeyboardInterrupt:
    pass

ws.disconnect()
exit(0)
