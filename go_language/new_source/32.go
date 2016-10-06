package main

/**
 * 如果匿名字段和外层结构体有同名字段的时候，操作方法
 *
 */

import (
	"fmt"
)

type A struct {
	s int
}

type B struct {
	A
	s int
}

func main() {
	a := B{s: 1, A: A{s: 2}}
	fmt.Println(a.s, a.A.s) //当A里面不存在的时候就会与B的相同  即上面没有就会自动向下去找
}
