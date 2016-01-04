package main

import (
	"fmt"
	"os"
)

/**
 * for循环
 * 四个参数   第四个还不知道怎么用
 * 开始 结束条件 步阶 随机数
 *
 */
func main() {
	var b int = 15
	var a int
	numbers := [6]int{1, 2, 3, 5}
	for a := 0; a < 10; a++ {
		fmt.Println(a)
	}
	fmt.Println("---------------------------------")
	for a < b {
		a++
		fmt.Println(a)
	}
	fmt.Println("---------------------------------")
	for i, x := range numbers {
		fmt.Printf("%d %d\n", x, i)
	}

	//下面的是死循环
	//for {
	//	 fmt.Println("我是死循环啊 死呀嘛 死循环");
	//}

	//for true {
	//	 fmt.Println("我是死循环啊 死呀嘛 死循环");
	//}

	//数组的循环方式
	s, sep := "", ""
	for _, arg := range os.Args[1:] {
		s += sep + arg
		sep = " "
	}
	fmt.Println(s)
}
