package main

/**
* 运算符: go语言中运算符是从左至右结合优先级(从高到低)
* ^ !                      (一元运算符)
* * / % << >> & &^         (二元运算符)
* == != < <= >= >

* <-                       (专门用于channel)
  &&
  ||
*/
import (
	"fmt"
)

func main() {
	fmt.Println(^3)      //输出结果是 -4
	fmt.Println(1 ^ 2)   //输出结果是 3
	fmt.Println(!true)   //输出false
	fmt.Println(1 << 10) //1左移10位  输出结果是1024  左移可以理解成是：每次左移10位，就是相当于原数*1024. 右移则相反
}
