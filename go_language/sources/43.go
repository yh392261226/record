package main

import (
	"fmt"
)

/**
 * 函数语法可以深度嵌套， 因此内部的一个声明可能屏蔽外部的声明。
 * 下面的代码有三个不同的变量x，因为它们是定义中不同的语法域，
 * （这个例子只是为了演示作用域规则，但不是好的变成风格）
 *
 * 注意：后面的表达式与unicode.ToUpper并不相同
 */

func main() {
	x := "hello!"
	for i := 0; i < len(x); i++ {
		x := x[i]
		if x != '!' {
			x := x + 'A' - 'a'
			fmt.Printf("%c", x) // "HELLO" (one letter per iteration)
		}
	}

}
