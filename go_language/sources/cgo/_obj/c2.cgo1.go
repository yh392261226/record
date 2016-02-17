// Created by cgo - DO NOT EDIT

//line /Users/json/working/go_language/sources/cgo/c2.go:1
package print
//line /Users/json/working/go_language/sources/cgo/c2.go:7

//line /Users/json/working/go_language/sources/cgo/c2.go:6
import "unsafe"
//line /Users/json/working/go_language/sources/cgo/c2.go:9

//line /Users/json/working/go_language/sources/cgo/c2.go:8
func Print(s string) {
	cs := _Cfunc_CString(s)
	defer _Cfunc_free(unsafe.Pointer(cs))
	_Cfunc_fputs(cs, (*_Ctype_struct___sFILE)(*_Cvar_stdout))
}
