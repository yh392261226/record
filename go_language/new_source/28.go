package main

/**
 * Go语言不是面向对象语言，但做了很多工作来贴近面向对象
 *
 *
 * 结构体 struct
 * go语言的 struct与C语言中的struct非常相似，并且GO语言中没有class
 * 使用Type <Name> struct{} 定义结构体，名称遵循可见性规则
 * 支持指向自身的指针类型成员
 * 支持匿名结构体，可用作成员或定义成员变量
 * 匿名结构体也可以用作map的值
 * 可以使用字面值对结构体进行初始化
 * 允许直接通过指针来读写结构体成员
 * 相同类型的成员可以直接通过拷贝赋值
 * 支持==与!=比较运算符，但不支持< >
 * 支持匿名字段，本质上是定义了以某个类型名为名称的字段
 * 嵌入结构体作为匿名字段，看起来像继承，但不是继承
 * 可以使用匿名字段指针
 * Go语言中没有继承的概念
 *
 */

import (
	"fmt"
)

//定义一个空的结构体
type test struct{}
type person struct {
	name string //默认为空
	age  int    //默认为0
}

func main() {
	a := test{}
	fmt.Println(a) //输出一个空的{}

	b := person{}
	b.name = "Json" //使用结构体里的成员 用. 类似js的属性
	b.age = 30
	fmt.Println(b) //{Json 30}

	//预制默认数据 默认初始化
	c := person{
		name: "tester", //需要注意这个结尾
		age:  1,        //每行的结尾都必须有这个,
	}
	fmt.Println(c) //{tester 1}

	A(c)
	fmt.Println(c) //{tester 1}

	B(&c)
	fmt.Println(c) //{tester 10}

	d := &person{ //结构初始化的时候取地址 开发中常见
		name: "tester1",
		age:  20,
	}
	C(d)
	fmt.Println(d) //&{tester1 11}

	//匿名结构体 可以不先预定义结构体
	e := &struct { //初始化时取地址， 去掉&就是正常的结构体初始化了
		name string
		age  int
	}{
		name: "niming",
		age:  1,
	}
	fmt.Println(e)
}

func A(per person) {
	per.age = 10
	fmt.Println("A", per) //A {tester 10}
}

func B(per *person) {
	per.age = 10
	fmt.Println("B", per) //B &{tester 10}
}

func C(per *person) {
	per.age = 11
	fmt.Println("C", per) //C &{tester1 11}
}
