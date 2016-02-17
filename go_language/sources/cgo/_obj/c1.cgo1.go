// Created by cgo - DO NOT EDIT

//line /Users/json/working/go_language/sources/cgo/c1.go:1
package rand
//line /Users/json/working/go_language/sources/cgo/c1.go:7

//line /Users/json/working/go_language/sources/cgo/c1.go:6
func Random() int {
	return int(_Cfunc_random())
}
//line /Users/json/working/go_language/sources/cgo/c1.go:11

//line /Users/json/working/go_language/sources/cgo/c1.go:10
func Seed(i int) {
	_Cfunc_srandom(_Ctype_uint(i))
}
