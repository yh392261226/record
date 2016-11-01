package main

/**
 * switch语句
 * 可以使用任何类型或表达式作为条件语句
 * 不需要写break，一单条件符合自动终止
 * 如果希望继续执行下一个case，需要使用fallthrough语句
 * 支持一个初始化表达式(可以是并行方式)，右侧需跟分号
 * 左大括号必须和条件语句在同一行
 */

import (
	"fmt"
)

func main() {
	a := 1
	switch a { //经典使用方法
	case 0:
		fmt.Println("a is 0")
	case 1:
		fmt.Println("a is 1")
	default:
		fmt.Println("a is none")
	}

	b := 1
	//switch的另一种用法
	switch { //fallthrough用法 即第一满足条件的case执行后继续下一个case
	case b >= 0:
		fmt.Println("b is 0")
		fallthrough
	case b >= 1:
		fmt.Println("b is 1")
	default:
		fmt.Println("b is none")
	}

	//switch的第三种用法
	switch c := 1; {
	case c >= 0:
		fmt.Println("c >= 0")
	case c >= 1:
		fmt.Println("c >= 1")
	default:
		fmt.Println("c is none")
	}
}
