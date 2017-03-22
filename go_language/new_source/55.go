package main

import (
	"fmt"
	"reflect"
)

type User struct {
	Id   int
	Name string
	Age  int
}

type Manager struct {
	User  //名称和类型都是User 其实这是一个匿名字段
	title string
}

func main() {
	T1()
	fmt.Println("................")
	T2()
	fmt.Println("................")
	T3()
	fmt.Println("................")
	T4()
	fmt.Println("................")
}

//通过索引获取字段或反射
func T1() {
	m := Manager{User: User{1, "OK", 12}, title: "123"}
	t := reflect.TypeOf(m)

	fmt.Printf("%#v\n", t.Field(0))                  //打印反射类型索引为0的详细字段
	fmt.Printf("%#v\n", t.FieldByIndex([]int{0, 0})) //传递一个int型的slice取匿名字段中的字段
}

//获得对象然后修改值
func T2() {
	x := 123
	v := reflect.ValueOf(&x) //传递的是指针
	v.Elem().SetInt(999)
	fmt.Println(x)
}

//设置值
func T3() {
	u := User{1, "OK", 12}
	Set(&u)
	fmt.Println(u)
}

//设置值 及防止程序崩溃的判断
func Set(o interface{}) {
	v := reflect.ValueOf(o)

	if v.Kind() == reflect.Ptr && !v.Elem().CanSet() {
		fmt.Println("无法修改")
		return
	} else {
		v = v.Elem()
	}

	f := v.FieldByName("Name")
	//想要出发下面的无法找到
	//f := v.FieldByName("Name1")
	//判断是否能找到该字段
	if !f.IsValid() {
		fmt.Println("无法找到")
		return
	}
	//设置字段值成功
	if f.Kind() == reflect.String {
		f.SetString("BYE BYE")
	}
}

//反射动态调用方法
func (u User) Hello(name string) {
	fmt.Println("Hello", name, ", my name is", u.Name)
}

func T4() {
	u := User{1, "OK", 12}
	// u.Hello("joe")
	//注释的这行其实与下面的这一堆是一样的结果
	v := reflect.ValueOf(u)
	mv := v.MethodByName("Hello")

	args := []reflect.Value{reflect.ValueOf("joe")}
	mv.Call(args)
}
