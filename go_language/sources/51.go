package main

/**
 * 类似php的EOT
 * 反引号内的内容不转义
 */

import p "fmt"

func main() {
	str := `this is 
	a long string`
	p.Println(str)
}
