## seashell

A simple python/c interop library made for Windows.

Not production ready, you should just use ctypes anyway. Made for learning purposes

### Basic usage

Create a `Dll` instance and call a method on it.

```py
from seashell import *
kernel32: Dll = Dll("kernel32.dll")
kernel32.Beep(440, 500)
```

This example plays a 440hz beep for 500ms.

String literals are supported. Normal string literals are passed as `wchar_t*`, and
bytes literals are passed as `char*`
```py
MB_OK: int = 0

user32 = Dll("user32.dll")
user32.MessageBoxA(0, b"Hello from seashell!", b"Title", MB_OK) # Ascii string
user32.MessageBoxW(0, "Hello from seashell!", "Title", MB_OK) # Wide string
```

### Features
 - Supports string arguments, as shown above
 - Supports arbitrary amount of parameters

### Limitations

 - No custom structs for now
   - Large structs in C are passed with a hidden pointer to the struct on the stack
   - It is technically possible to pass small structs if they fit in one register slot
     (i.e. exactly 1/2/4/8 bytes) by replicating the value as an int
   - Need to figure out a good way of declaring the layout of the struct and passing it around
 - Can't use native arrays.
   - If you happen to have a way to allocate them, and have a pointer to the start of an array, that will work though. Pass it as any type, it's the bit layout that matters
  - Incorrect parameters = memory go boom. Be careful to match the signature of the method you're calling
  - No way to call function pointers directly. May be a feature in the future, the internal API already supports it

## Building
After cloning the repo, you'll need to create `seashell-native\python.props`. You can copy `python.example.props`, but make sure to replace PythonDir with the path to your Python installation.

You should set DemoApplication as your startup project to test out some features!
