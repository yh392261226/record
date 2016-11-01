package main

/**
 * 指针
 * go语言虽然有指针 但不支持指针运算
 */

import (
	"fmt"
)

func main() {
	a := 1
	var p *int = &a
	fmt.Println(p)  //输出内存地址
	fmt.Println(*p) //输出内存地址的内容
}
