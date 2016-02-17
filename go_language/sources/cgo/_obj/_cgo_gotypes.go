// Created by cgo - DO NOT EDIT

package rand

import "unsafe"

import _ "runtime/cgo"

import "syscall"

var _ syscall.Errno
func _Cgo_ptr(ptr unsafe.Pointer) unsafe.Pointer { return ptr }

//go:linkname _Cgo_always_false runtime.cgoAlwaysFalse
var _Cgo_always_false bool
//go:linkname _Cgo_use runtime.cgoUse
func _Cgo_use(interface{})
type _Ctype_long int64

type _Ctype_uint uint32

type _Ctype_void [0]byte

//go:linkname _cgo_runtime_cgocall runtime.cgocall
func _cgo_runtime_cgocall(unsafe.Pointer, uintptr) int32

//go:linkname _cgo_runtime_cmalloc runtime.cmalloc
func _cgo_runtime_cmalloc(uintptr) unsafe.Pointer

//go:linkname _cgo_runtime_cgocallback runtime.cgocallback
func _cgo_runtime_cgocallback(unsafe.Pointer, unsafe.Pointer, uintptr)

//go:cgo_import_static _cgo_03b16e7ad4e2_Cfunc_random
//go:linkname __cgofn__cgo_03b16e7ad4e2_Cfunc_random _cgo_03b16e7ad4e2_Cfunc_random
var __cgofn__cgo_03b16e7ad4e2_Cfunc_random byte
var _cgo_03b16e7ad4e2_Cfunc_random = unsafe.Pointer(&__cgofn__cgo_03b16e7ad4e2_Cfunc_random)

func _Cfunc_random() (r1 _Ctype_long) {
	_cgo_runtime_cgocall(_cgo_03b16e7ad4e2_Cfunc_random, uintptr(unsafe.Pointer(&r1)))
	if _Cgo_always_false {
	}
	return
}
//go:cgo_import_static _cgo_03b16e7ad4e2_Cfunc_srandom
//go:linkname __cgofn__cgo_03b16e7ad4e2_Cfunc_srandom _cgo_03b16e7ad4e2_Cfunc_srandom
var __cgofn__cgo_03b16e7ad4e2_Cfunc_srandom byte
var _cgo_03b16e7ad4e2_Cfunc_srandom = unsafe.Pointer(&__cgofn__cgo_03b16e7ad4e2_Cfunc_srandom)

func _Cfunc_srandom(p0 _Ctype_uint) (r1 _Ctype_void) {
	_cgo_runtime_cgocall(_cgo_03b16e7ad4e2_Cfunc_srandom, uintptr(unsafe.Pointer(&p0)))
	if _Cgo_always_false {
		_Cgo_use(p0)
	}
	return
}
