package main

import (
	"fmt"
)

/**
 * 变量赋值的四种等价方法及使用
 *
 * 第一种形式 只能用在函数内部， 而package级别的变量，禁止使用这样的声明方式。
 * 第二种形式 依赖于string类型的内部初始化机制，被初始化为空字符串。
 * 第三种形式 使用的很少，除非同时声明多个变量。
 * 第四种形式 会显示标明变量的类型 让编译器去初始化它的值，或直接用隐式初始化，标明初始值怎样并不重要。
 */
func main() {
	s := ""
	var ss string
	ss = ""
	var sss = ""
	var ssss string = ""
	//以上四种形式  是等价的

	fmt.Println(s)
	fmt.Println(ss)
	fmt.Println(sss)
	fmt.Println(ssss)
}
