package main

import (
	"fmt"
)

const a int = 1
const b = 'A'

const (
	c = 1
	d = 2
	e = 3
)

const m, n = 4, 5

const (
	nn, mm = 11, 22
)

const ( //如果后面的t2 t3不赋值的话 就会跟t1一个值  默认使用上一个的
	t1 = 1
	t2
	t3
	t4 = 3
	t5
)

//有意思的赋值 常量表达式中只能出现表达式 不能有运行时才产生的变量
const (
	aa = "123"
	bb = len(aa)
	cc
)

const (
	aaa, bbb = 123, 345
	ccc, ddd //值是123, 345
)

func main() {
	fmt.Println(a)
	fmt.Println(b)
	fmt.Println(c)
	fmt.Println(d)
	fmt.Println(e)
	fmt.Println(m)
	fmt.Println(n)
	fmt.Println(nn)
	fmt.Println(mm)
	fmt.Println(t1)
	fmt.Println(t2)
	fmt.Println(t3)
	fmt.Println(t4)
	fmt.Println(t5)
	fmt.Println(aa)
	fmt.Println(bb)
	fmt.Println(cc)
	fmt.Println(ccc)
	fmt.Println(ddd)
}
