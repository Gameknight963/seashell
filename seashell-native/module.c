#define PY_SSIZE_T_CLEAN
#include <python.h>
#include <windows.h>

extern long long asm_call(
    void* fn_ptr,
    int argc,
    long long* argv,
    char* is_float,
    char is_float_return
);

// "_alloca indicates failure by raising a stack overflow exception"
#pragma warning(disable: 6255)

static PyObject* asm_call_py(PyObject* self, PyObject* const* args, Py_ssize_t nargs) {
    if (nargs != 4) {
        PyErr_SetString(PyExc_TypeError, "expected (fn_ptr, argv, is_float, is_float_ret)");
        return NULL;
    }
    void* fn_ptr = PyLong_AsVoidPtr(args[0]);
    Py_ssize_t argc = PyList_Size(args[1]);
    long long* argv = (long long*)alloca(argc * sizeof(long long));
    char* is_float = (char*)alloca(argc * sizeof(char));
    char is_float_return = PyObject_IsTrue(args[3]);
    for (Py_ssize_t i = 0; i < argc; i++) {
        PyObject* arg = PyList_GetItem(args[1], i);
        PyObject* float_flag = PyList_GetItem(args[2], i);

        is_float[i] = PyObject_IsTrue(float_flag);

        if (is_float[i]) {
            double d = PyFloat_AsDouble(arg);
            memcpy(&argv[i], &d, 8);
        }
        else if (PyBytes_Check(arg)) {
            argv[i] = (long long)PyBytes_AsString(arg);
        }
        else if (PyUnicode_Check(arg)) {
            argv[i] = (long long)PyUnicode_AsWideCharString(arg, NULL);
        }
        else {
            argv[i] = PyLong_AsLongLong(arg);
        }
    }
    long long result = asm_call(fn_ptr, argc, argv, is_float, is_float_return);
    return is_float_return ? PyFloat_FromDouble(result) : PyLong_FromLongLong(result);
}

static PyObject* load_library(PyObject* self, PyObject* const* args, Py_ssize_t nargs) {
    if (nargs != 1) {
        PyErr_SetString(PyExc_TypeError, "expected (path,)");
        return NULL;
    }

    const wchar_t* path = PyUnicode_AsWideCharString(args[0], NULL);
    if (!path) return NULL;

    HMODULE handle = LoadLibraryW(path);
    if (!handle) {
        PyErr_SetFromWindowsErr(0);
        return NULL;
    }

    return PyLong_FromVoidPtr(handle);
}

static PyObject* free_library(PyObject* self, PyObject* const* args, Py_ssize_t nargs) {
    if (nargs != 1) {
        PyErr_SetString(PyExc_TypeError, "expected (handle)");
        return NULL;
    }
    HMODULE handle = PyLong_AsVoidPtr(args[0]);
    BOOL success = FreeLibrary(handle);
    if (!success) {
        PyErr_SetFromWindowsErr(0);
        return NULL;
    }
    Py_RETURN_NONE;
}

static PyObject* get_export(PyObject* self, PyObject* const* args, Py_ssize_t nargs) {
    if (nargs != 2) {
        PyErr_SetString(PyExc_TypeError, "expected (handle, name)");
        return NULL;
    }
    HMODULE handle = PyLong_AsVoidPtr(args[0]);
    char* name = PyBytes_AsString(args[1]);
    void* fn_ptr = GetProcAddress(handle, name);
    return PyLong_FromVoidPtr(fn_ptr);
}

static PyMethodDef methods[] = {
    {"call", asm_call_py, METH_FASTCALL, "Make an ffi call"},
    {"load_library", load_library, METH_FASTCALL, "Load a windows dll"},
    {"get_export", get_export, METH_FASTCALL, "Get an export from a windows dll"},
    {"free_library", free_library, METH_FASTCALL, "Free a library from a handle previously obtained with load_library"},
    {NULL, NULL, 0, NULL}
};

static struct PyModuleDef module = {
    PyModuleDef_HEAD_INIT, "seashell", NULL, -1, methods
};

PyMODINIT_FUNC PyInit__seashell(void) {
    return PyModule_Create(&module);
}