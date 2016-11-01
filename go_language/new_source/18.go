package main

/**
* 数组指针
*
 */

import (
	"fmt"
)

func main() {
	a := [...]int{99: 1}
	var p *[100]int = &a
	fmt.Println(p)

	//指针 访问返回内存地址
	x, y := 1, 2
	b := [...]*int{&x, &y}
	fmt.Println(b) //返回结果是两个内存的地址
}
