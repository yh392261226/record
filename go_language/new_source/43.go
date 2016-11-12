package main

import (
	"fmt"
)

/**
 * 语言类型转换
 * 基本格式如下：type_name ()
 *
 */

func main() {
	var sum int = 11
	var count int = 5
	var mean float32

	mean = float32(sum) / float32(count)
	fmt.Printf("mean 的值为:%f\n", mean)
}
