package main

/**
 * 反射 reflection
 * 反射可大大提高程序的灵活性，使得interface{}有更大的发挥余地
 * 反射使用TypeOf和ValueOf函数从接口中获取目标对象信息
 * 反射会将匿名字段作为独立字段(你名字段本质)
 * 想要利用反射修改对象状态,前提是interface.data是settable，即pointer-interface
 * 通过反射可以“动态”调用方法
 *
 */

import (
	"fmt"
	"reflect"
)

type User struct {
	Id   int
	Name string
	Age  int
}

func (u User) Hello() {
	fmt.Println("Hello world.")
}

func main() {
	u := User{1, "OK", 12} //声明一个类型
	Info(u)                //值拷贝传递进去Info
}

func Info(o interface{}) {
	t := reflect.TypeOf(o)
	fmt.Println("Type:", t.Name())

	if k := t.Kind(); k != reflect.Struct {
		fmt.Println("传递对象匿名不对")
		return
	}

	v := reflect.ValueOf(o)
	fmt.Println("Fields:")
	//打印基本的参数
	for i := 0; i < t.NumField(); i++ {
		f := t.Field(i)
		val := v.Field(i).Interface()
		fmt.Printf("%6s: %v=%v", f.Name, f.Type, val)
	}
	fmt.Println("")
	fmt.Println("Methods:")
	//打印方法
	for i := 0; i < t.NumMethod(); i++ {
		m := t.Method(i)
		fmt.Printf("%6s:%v\n", m.Name, m.Type)
	}
}
