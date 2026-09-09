#define PY_SSIZE_T_CLEAN
#include <Python.h>
#include <Windows.h>

typedef int (WINAPI* MessageBoxW_t)(HWND, LPCWSTR, LPCWSTR, UINT);

long long double_it(long long x) { return x * 2; }

extern long long asm_call_double(long long x);

static PyObject* hello(PyObject* self, PyObject* const* args, Py_ssize_t nargs) {
    return PyUnicode_FromString("hello from C!");
}

static PyObject* get_answer_py(PyObject* self, PyObject* const* args, Py_ssize_t nargs) {
    return PyLong_FromLongLong(asm_call_double(5));
}

static PyObject* call_messagebox(PyObject* self, PyObject* const* args, Py_ssize_t nargs) {
    if (nargs != 2) {
        PyErr_SetString(PyExc_TypeError, "expected (text, caption)");
        return NULL;
    }
    const wchar_t* text = PyUnicode_AsWideCharString(args[0], NULL);
    const wchar_t* caption = PyUnicode_AsWideCharString(args[1], NULL);
    if (!text || !caption) {
        PyErr_SetString(PyExc_TypeError, "arguments must be strings");
        return NULL;
    }

    HMODULE lib = LoadLibraryW(L"user32.dll");
    if (!lib) {
        PyErr_SetFromWindowsErr(0);
        return NULL;
    }
    MessageBoxW_t fn = (MessageBoxW_t)GetProcAddress(lib, "MessageBoxW");
    int result = fn(NULL, text, caption, 0);

    return PyLong_FromLong(result);
}

static PyMethodDef methods[] = {
    {"hello", hello, METH_FASTCALL, "Returns a greeting"},
    {"call_messagebox", call_messagebox, METH_FASTCALL, "Message box"},
    {"get_answer", get_answer_py, METH_FASTCALL, "Gets a number, made in asm"},
    {NULL, NULL, 0, NULL}
};

static struct PyModuleDef module = {
    PyModuleDef_HEAD_INIT,
    "seashell",
    NULL,
    -1,
    methods
};

PyMODINIT_FUNC PyInit_seashell(void) {
    return PyModule_Create(&module);
}