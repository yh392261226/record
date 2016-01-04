package main

import (
	"fmt"
)

/**
 * 数组
 * 一维数组： var 变量名 [值的个数] 值的类型
 * 多维数组： var variable_name [SIZE1][SIZE2]...[SIZEN] variable_type
 */
func main() {
	var arr [3]string
	arr[0] = "222"
	arr[2] = "333"
	arr[1] = "444"
	fmt.Println(arr[1])
}
