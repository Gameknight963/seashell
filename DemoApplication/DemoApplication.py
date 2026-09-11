from seashell import *

kernel32: Dll = Dll("kernel32.dll")
kernel32.Beep(440, 500)

# user32: Dll = Dll("user32.dll")
# user32.MessageBeep(0)