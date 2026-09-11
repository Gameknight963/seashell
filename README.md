## seashell

A simple python/c interop library made for Windows.

Not production ready, you should just use ctypes anyway. Made for learning purposes

### Usage

Create a `Dll` instance and call a method on it.

```py
from seashell import *
kernel32: Dll = Dll("kernel32.dll")
kernel32.Beep(440, 500)
```

This example plays a 440hz beep for 500ms.

### Limitations for now

 - Max 4 arguments
   - In Windows, any arguments after the first four go on the stack instead
     of on registers, and I have no way of handling that currently
 - Arguments can only be int64 or double
   - Large structs in C are passed with a hidden pointer to the struct on the stack
   - It is technically possible to pass small structs if they fit in one register slot
     (i.e. exactly 1/2/4/8 bytes) by replicating the value as an int
 - Can't use native arrays / types / c-strings
   - This would require some marshaling implementation, doable but not trivial
  
## Building
After cloning the repo, you'll need to create `seashell-native\python.props`. You can copy `python.example.props`, but make sure to replace PythonDir with the path to your Python installation.

You should set DemoApplication as your startup project
