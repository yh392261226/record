package main

/**
 * 方法 method （就是类）
 * Go语言中虽然没有class 但是依旧有method
 * 通过显示说明receiver来实现与某个类型的组合
 * 只能为同一个包中的类型定义方法
 * receiver可以说类型的值或者指针
 * 不存在方法重载
 * 可以使用值或指针来调用方法，编译器会自动完成转换
 * 从某种意义上来说，方法是函数的语法糖，因为receiver其实就是方法所接受的第一个参数（Method Value vs. Method Expression）
 * 如果外部结构和嵌入结构存在同名方法，则优先调用外部结构的方法
 * 类型别名不会拥有底层类型所附带的方法
 * 方法可以调用结构中的非公开字段
 * 方法与类型是绑定的
 *
 */

import (
	"fmt"
)

type A struct {
	name string
}

type B struct {
	name string
}

type C struct {
	name string
}

func main() {
	a := A{}
	a.Print()

	b := B{}
	b.Print()

	c := C{}
	c.Print()
	fmt.Println(c.name)
}

/**
 * 方法method
 * 这是一个打印方法
 */
func (a A) Print() {
	fmt.Println("A")
}

/**
 * 方法与类型绑定的
 * 例如该方法 与类型B 是互相绑定的
 */
func (b B) Print() {
	fmt.Println("B")
}

/**
 * 指针传递值
 */
func (c *C) Print() {
	c.name = "this is c"
	fmt.Println("C")
}
