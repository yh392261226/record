package main

import (
	"fmt"
)

/**
 * strct语言结构
 * 感觉类似php的关联数组
 * 这里还有引用&  引用会修改源数据
 */

func main() {
	fmt.Println(person{"Bob", 20})
	fmt.Println(person{name: "Alice", age: 30})
	fmt.Println(person{name: "Fred"})
	fmt.Println(&person{name: "Anna", age: 20})

	s := person{name: "Sean", age: 50}
	fmt.Println(s.name)

	sp := &s
	fmt.Println(sp.age)

	sp.age = 44
	fmt.Println(sp.age)
	fmt.Println(s.age)
}

/**
 * type 声明一个数据类型struct
 * 这里还不是很清楚type和struct  需要再学习一下
 */
type person struct {
	name string
	age  int
}
