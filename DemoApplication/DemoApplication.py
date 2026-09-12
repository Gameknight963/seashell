import time
from seashell import *

kernel32: Dll = Dll("kernel32.dll")

REST = 0
C4  = 262
D4  = 294
E4  = 330
F4  = 349
G4  = 392
A4  = 440
B4  = 494
C5  = 523
D5  = 587
E5  = 659
F5  = 698
G5  = 784
A5  = 880
B5  = 988

# Based on 144 BPM
BPM = 144
BEAT = int(60000 / BPM) # quarter note
HALF = BEAT * 2 # half note
Q = BEAT # quarter note. It would be distinct from BEAT under certain time signature
EIGHTH = BEAT // 2 # eighth note
DOT_Q = int(BEAT * 1.5) # dotted quarter note

tetris_melody: list = [

    (E5, Q), (B4, EIGHTH), (C5, EIGHTH), (D5, Q), (C5, EIGHTH), (B4, EIGHTH),
    (A4, Q), (A4, EIGHTH), (C5, EIGHTH), (E5, Q), (D5, EIGHTH), (C5, EIGHTH),
    (B4, DOT_Q), (C5, EIGHTH), (D5, Q), (E5, Q),
    (C5, Q), (A4, Q), (A4, Q), (REST, EIGHTH),

    (D5, DOT_Q), (F5, EIGHTH), (A5, Q), (G5, EIGHTH), (F5, EIGHTH),
    (E5, DOT_Q), (C5, EIGHTH), (E5, Q), (D5, EIGHTH), (C5, EIGHTH),
    (B4, Q), (B4, EIGHTH), (C5, EIGHTH), (D5, Q), (E5, Q),
    (C5, Q), (A4, Q), (A4, HALF),
]

def play(melody: list):
    for pitch, duration in melody:
        if pitch == REST:
            time.sleep(duration / 1000.0)
        else:
            # Leave a tiny 20ms gap so consecutive identical notes articulate cleanly
            play_ms: int = max(duration - 20, 10)
            kernel32.Beep(pitch, play_ms)
            time.sleep(0.02)


test: Dll = Dll("test.dll")
print(test.add1(1))
print(test.add2(1,2))
print(test.add3(1,2,3))
print(test.add4(1,2,3,4))
print(test.add5(1,2,3,4,5))
print("an iq too high??")

print("listen to this")
play(tetris_melody)

print("its missing something...")
time.sleep(1)

print("muahahahahha")
print(test.add6())
