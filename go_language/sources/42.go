package main

import (
	"fmt"
)

/**
 * 当编译器遇到一个变量引用时，如果它看起来像一个声明，它首先从最内层的语法域向
 * 全局的作用域查找。
 * 查找失败就报未声明变量的错误，如果该变量在内部和外部的语法块分别声明过，则内
 * 部语法块的声明先被找到。这种情况下，内部的声明屏蔽了外部同名的声明。让外部的
 * 声明变量无法被访问。
 *
 */

func f() {}

var g = "g"

func main() {
	f := "f"
	fmt.Println(f) // "f" local var f shadows package-level func f
	fmt.Println(g) // "g" package-level var
	//fmt.Println(h) // compile error: undefined h
}
