package main

/**
 * 嵌入结构   组合
 *
 */

import (
	"fmt"
)

type people struct {
	Sex int
	age int
}

type teacher struct {
	people
	Name string
}

type student struct {
	people
	class int
}

func main() {
	a := teacher{Name: "teacher1", people: people{Sex: 0, age: 12}} //必须要这样写才能嵌入进来 也叫组合起来
	b := student{people: people{Sex: 1, age: 22}, class: 3}
	a.Name = "tester"
	a.Sex = 10 //这里是可以直接当成自己的来使用的  类似于php的属性继承
	// 当然  a.people.Sex = 10 也是一样的  这种留着的原因就是为了避免冲突
	fmt.Println(a, b)
}
