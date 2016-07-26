package main

import (
	"fmt"
)

type (
	byte     int8
	rune     int32
	文本       string
	ByteSite int64
)

func main() {
	var b 文本
	b = "中文类型名"
	fmt.Println(b)
}
