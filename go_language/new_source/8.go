package main

/**
 * iota 是常量的计数器  从0开始 组中每定义一个常量自动增1
 * 每遇到一个const关键字 iota自动重置为0
 *
 */
import (
	"fmt"
)

const (
	a = 'A'  //65
	b        //65
	c = iota //2
	d        //3
)

const (
	e = iota //0
)

func main() {
	fmt.Println(a)
	fmt.Println(b)
	fmt.Println(c)
	fmt.Println(d)
	fmt.Println(e)
}
