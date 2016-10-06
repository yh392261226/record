package main

/**
 * 比较
 *
 */

import (
	"fmt"
)

type person struct {
	Name string
	Age  int
}

type person1 struct {
	Name string
	Age  int
}

func main() {
	a := person{Name: "tester", Age: 20}
	// b := person1{Name: "tester1", Age: 21}
	// fmt.Println(a == b) //会报错 因为不是同一类型 没有可比性
	c := person{Name: "tester", Age: 20}
	fmt.Println(a == c) //true
}
