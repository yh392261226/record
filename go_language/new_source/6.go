package main

/**
 * 想把数字转换成字符串后输出的还是数字 就用strconv 否则输出的是A
 *
 */
import (
	"fmt"
	"strconv"
)

func main() {
	var a int = 65
	b := strconv.Itoa(a)
	fmt.Println(b)
	//想再转换回来
	a, _ = strconv.Atoi(b)
	fmt.Println(a)
}
