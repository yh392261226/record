package main

/**
 * 匿名结构体
 *
 *
 */

import (
	"fmt"
)

type person struct {
	name    string
	age     int
	contact struct { //结构体的成员可以是结构体
		phone, city string
	}
}
type person2 struct { //匿名结构体属性 初始化的时候变量顺序不能错否则报错
	string
	int
}

func main() {
	a := person{}
	fmt.Println(a) //{ 0 { }}

	b := person{
		name: "tester",
		age:  10,
	}
	b.contact.phone = "12763435234"
	b.contact.city = "Haerbin"
	fmt.Println(b)

	c := person2{}
	fmt.Println(c)
}
