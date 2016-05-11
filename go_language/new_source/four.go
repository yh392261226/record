package main

import (
	"fmt"
)

/**
  声明单个变量与赋值
	变量的声明格式：var <变量名称> <变量类型>
	变量的赋值格式：<变量名称> = <表达式>
	声明的同时赋值：var <变量名称> [变量类型] = <表达式>
*/

func main() {
	var b int
	b = 1
	fmt.Println(b)
	c := 1
	fmt.Println(c)
	d := false
	fmt.Println(d)
}
