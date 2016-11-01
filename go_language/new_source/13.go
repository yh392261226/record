package main

/**
 * if语句
 *
 */
import (
	"fmt"
)

func main() {
	if i := 1; i < 10 { //这里的i 在if语句完成后就自动销毁了 再在下面输出就没有i这个变量了  go的if支持在判断之前先声明
		fmt.Println(i)
		i++
	}

	//如果在这个if语句块上面定义了一个a变量  那么在if语句块中外面的那个变量a就会被隐藏起来
	a := 100
	if a := 2; a > 1 {
		fmt.Println(a)
	}
	fmt.Println(a)

	//如果想在if语句块中使用外部的变量m
	m := 3
	if m < 5 {
		fmt.Println(m)
	}
	fmt.Println(m)
}
