#define PY_SSIZE_T_CLEAN
#include <Python.h>

extern long long asm_call(
    void* fn_ptr,
    int argc,
    long long* argv,
    char* is_float,
    char is_float_return
);

double add_floats(double a, double b) {
    return a + b;
}

static PyObject* test_asm_call(PyObject* self, PyObject* const* args, Py_ssize_t nargs) {
    double a = 1.5, b = 2.5;
    long long argv[] = { *(long long*)&a, *(long long*)&b };
    char is_float[] = { 1, 1 };
    long long result = asm_call(add_floats, 2, argv, is_float, 1);
    double dresult = *(double*)&result;
    return PyFloat_FromDouble(dresult);
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