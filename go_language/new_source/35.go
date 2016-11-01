package main

/**
 * 方法中是可以访问私有字段的
 * 即小写的私有类型 也是可以通过方法method进行访问的
 *
 */

import (
	"fmt"
)

type A struct {
	name string
}

func main() {
	a := A{}
	a.Print()

	fmt.Println(a.name)
}

func (a *A) Print() {
	a.name = "222"
	fmt.Println(a.name)
}
