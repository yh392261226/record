package main

/**
 * 跳转语句
 * goto break continue
 * 三个语法都可以配合标签使用
 * 标签名区分大小写，若不适用会造成编译错误
 * break与continue配合标签可用于多层循环的跳出
 * goto是调整执行位置，与其他2个语句配合标签的结果并不相同
 */

import (
	"fmt"
)

func main() {
	//break
LABEL1:
	for {
		for i := 0; i < 10; i++ {
			if i > 3 {
				break LABEL1 //默认break会跳出一层循环 但跟标签了就会跳出到跟LABEL1同一级的循环外
			}
		}
	}
	fmt.Println("OK1")
	//goto
	for {
		for i := 0; i < 10; i++ {
			if i > 3 {
				goto LABEL2 //goto 会直接跳到设定的地方
			}
		}
	}
LABEL2:
	fmt.Println("OK2")
	//continue
LABEL3:
	for i := 0; i < 10; i++ {
		for {
			continue LABEL3 //直接继续下一次循环 本次的循环并不被执行
			fmt.Println(i)
		}
	}
	fmt.Println("OK3")
}
