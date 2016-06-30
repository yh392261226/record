package main

/**
 *
 *
 */
import (
	"fmt"
)

const (
	B  float64 = 1 << (iota * 10)
	KB         //这里默认iota根据上面的iota是0 现在它是1 没有设定类型会接上面的 一样的类型
	MB         //根据上面的一样
	GB         //跟上面的一样
)

func main() {
	fmt.Println(1 << 10) //将1 左移10位 得到1024
	fmt.Println(B)
	fmt.Println(KB)
	fmt.Println(MB)
	fmt.Println(GB)
}
