__declspec(dllexport) long long add1(long long a) { 
	return a; 
}
__declspec(dllexport) long long add2(long long a, long long b) { 
	return a + b; 
}
__declspec(dllexport) long long add3(long long a, long long b, long long c) { 
	return a + b + c; 
}
__declspec(dllexport) long long add4(long long a, long long b, long long c, long long d) { 
	return a + b + c + d;
}
__declspec(dllexport) long long add5(long long a, long long b, long long c, long long d, long long e) { 
	return a + b + c + d + e;
}
__declspec(dllexport) double fadd2(double a, double b) { 
	return a + b; 
}
__declspec(dllexport) double fadd4(double a, double b, double c, double d) { 
	return a + b + c + d; 
}