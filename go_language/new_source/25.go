package main

/**
 * 函数 function
 * go 语言函数不支持嵌套、重载和默认参数
 * 但支持一下特性：
 * 无需声明原型、不定长度变参、多返回值、命名返回值参数、匿名函数、闭包
 * 定义函数使用关键字func，且左侧大括号不能另起一行
 * 函数也可以作为一种类型使用
 */

import (
	"fmt"
)

func main() {
	A(1, 2, 3, 4)
	fmt.Println("-引用类型与值类型-----------------------------------")
	yinyong()
	fmt.Println("-函数类型的值-----------------------------------")
	test := TEST //注意这里在当函数是值的时候  是不需要加后面的括号的
	test()
	fmt.Println("-匿名函数-----------------------------------")
	myFunc()
	fmt.Println("-闭包-----------------------------------")
	f := closure(10)
	fmt.Println(f(1))
	fmt.Println(f(2))
}

func A(a ...int) { // 函数名(变量 属性， 变量 属性) 返回值类型 {
	//如果参数类型相同可以这样写：(a, b, c int) 同理 多个返回值也可以这样写：A() (a, b, c int) {
	//参数不定长变参 即参数个数不固定， 可以写成 A(a ...int) 不定长变参后面不能再跟别的参数变量  但是可以放前面啊A(b string, a ...int)
  //补充：不定长变参，只能在参数列表的最后
	fmt.Println(a)
	return
	// return a //返回值
}

/**
 * 值类型与引用类型
 *
 *
 * 引用类型
 */
func yinyong() {
	a := 1
	zhijiechuandi(a)
	fmt.Println(a)
	zhizhen(&a)
	fmt.Println(a)
	//结果是3 1 2 2
}

/**
 * 指针
 */
func zhizhen(a *int) {
	*a = 2
	fmt.Println(*a)
}

/**
 * 直接传递值
 */
func zhijiechuandi(a int) {
	a = 3
	fmt.Println(a)
}

/**
 * 函数类型的值
 */
func TEST() {
	fmt.Println("I am a test")
}

/**
 * 匿名函数
 */
func myFunc() {
	a := func() {
		fmt.Println("This is a unnamed function")
	}
	a()
}

/**
 * 闭包
 */
func closure(x int) func(int) int {
	fmt.Printf("%p\n", &x) //三次打印的地址都是x在内存的地址
	return func(y int) int {
		fmt.Printf("%p\n", &x) //三次打印的地址都是x在内存的地址
		return x + y
	}
}
