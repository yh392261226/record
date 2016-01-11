package main

import (
	"fmt"
)

/**
 * 下面这个例子同样有三个不同的x变量，每个声明在不同语法域，一个在函数体， 一个
 * 在for隐式的初始化语法域， 一个在for循环语法域里。只有两个块是显示创建的：
 *
 *
 */

func main() {
	x := "hello"
	for _, x := range x {
		x := x + 'A' - 'a'
		fmt.Printf("%c", x) //HELLO one leeter per interation
	}
}
