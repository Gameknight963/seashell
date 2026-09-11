import _seashell as seashell

class Dll:
    _handle: int
    def __init__(self, name: str):
        self._handle = seashell.load_library(name)

    def __del__(self):
        seashell.free_library(self._handle);

    def __getattr__(self, name: str):
        ptr: int = seashell.get_export(self._handle, name.encode())
        def call_fn(*args, ret_float: bool = False):
            is_float = [isinstance(a, float) for a in args]
            return seashell.call(ptr, list(args), is_float, ret_float)
        return call_fn