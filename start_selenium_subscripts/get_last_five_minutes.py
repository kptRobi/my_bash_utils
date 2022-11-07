# 1 - Brak podanych argumentow

import sys
import shutil
from moviepy.editor import *
from moviepy.video.io.ffmpeg_tools import ffmpeg_extract_subclip

if len(sys.argv) < 3:
    sys.exit(1)
    
source = sys.argv[1]
destination = sys.argv[2]

clip = VideoFileClip(source)
koniec = clip.duration - 1
start = koniec - 300

if start > 0:
    ffmpeg_extract_subclip(source, start, koniec, destination)
else:
    shutil.copyfile(source, destination)
    
sys.exit(0)
