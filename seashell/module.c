#define PY_SSIZE_T_CLEAN
#include <Python.h>

static PyObject* hello(PyObject* self, PyObject* args) {
    return PyUnicode_FromString("hello from C!");
}

static PyMethodDef methods[] = {
    {"hello", hello, METH_VARARGS, "Returns a greeting"},
    {NULL, NULL, 0, NULL}
};

static struct PyModuleDef module = {
    PyModuleDef_HEAD_INIT,
    "mymodule",
    NULL,
    -1,
    methods
};

PyMODINIT_FUNC PyInit_seashell(void) {
    return PyModule_Create(&module);
}