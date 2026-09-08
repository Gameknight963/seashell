#define PY_SSIZE_T_CLEAN
#include <Python.h>

static PyObject* hello(PyObject* self, PyObject* const* args, Py_ssize_t nargs) {
    return PyUnicode_FromString("hello from C!");
}

static PyMethodDef methods[] = {
    {"hello", hello, METH_FASTCALL, "Returns a greeting"},
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