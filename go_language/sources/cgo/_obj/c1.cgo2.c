#line 3 "/Users/json/working/go_language/sources/cgo/c1.go"
 #include <stdlib.h>



// Usual nonsense: if x and y are not equal, the type will be invalid
// (have a negative array count) and an inscrutable error will come
// out of the compiler and hopefully mention "name".
#define __cgo_compile_assert_eq(x, y, name) typedef char name[(x-y)*(x-y)*-2+1];

// Check at compile time that the sizes we use match our expectations.
#define __cgo_size_assert(t, n) __cgo_compile_assert_eq(sizeof(t), n, _cgo_sizeof_##t##_is_not_##n)

__cgo_size_assert(char, 1)
__cgo_size_assert(short, 2)
__cgo_size_assert(int, 4)
typedef long long __cgo_long_long;
__cgo_size_assert(__cgo_long_long, 8)
__cgo_size_assert(float, 4)
__cgo_size_assert(double, 8)

extern char* _cgo_topofstack(void);

#include <errno.h>
#include <string.h>

void
_cgo_03b16e7ad4e2_Cfunc_random(void *v)
{
	struct {
		long int r;
	} __attribute__((__packed__)) *a = v;
	char *stktop = _cgo_topofstack();
	__typeof__(a->r) r = random();
	a = (void*)((char*)a + (_cgo_topofstack() - stktop));
	a->r = r;
}

void
_cgo_03b16e7ad4e2_Cfunc_srandom(void *v)
{
	struct {
		unsigned int p0;
		char __pad4[4];
	} __attribute__((__packed__)) *a = v;
	srandom(a->p0);
}

