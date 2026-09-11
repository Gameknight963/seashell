import seashell

kernel32: int = seashell.load_library("kernel32.dll")
beep: int = seashell.get_export(kernel32, b"Beep")
seashell.call(beep, [440, 500], [False, False], False)