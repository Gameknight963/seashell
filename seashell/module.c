#define PY_SSIZE_T_CLEAN
#include <Python.h>

extern long long asm_call(
    void* fn_ptr,
    int argc,
    long long* argv,
    char* is_float
);

long long add(long long a, long long b) {
    return a + b;
}

static PyObject* test_asm_call(PyObject* self, PyObject* const* args, Py_ssize_t nargs) {
    long long argv[] = { 10, 20 };
    char is_float[] = { 0, 0 };
    long long result = asm_call(add, 2, argv, is_float);
    return PyLong_FromLongLong(result);
}

static PyMethodDef methods[] = {
    {"test_asm_call", (PyCFunction)test_asm_call, METH_FASTCALL, "Test asm_call"},
    {NULL, NULL, 0, NULL}
};

static struct PyModuleDef module = {
    PyModuleDef_HEAD_INIT, "seashell", NULL, -1, methods
};

PyMODINIT_FUNC PyInit_seashell(void) {
    return PyModule_Create(&module);
}