from seashell import *

kernel32: Dll = Dll("kernel32.dll")
kernel32.Beep(440, 500)
# seashell.call(beep, [440, 500], [False, False], False)