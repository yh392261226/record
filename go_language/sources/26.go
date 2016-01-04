package main

import (
	"fmt"
	"os"
	"strings"
)

/**
 * 如果频繁的连接字符串 成本会非常高 更简单有效的方式是使用string包提供的join函数
 *
 * 使用方法    go run 26.go 1 2 3 4 5
 */
func main() {
	fmt.Println(strings.Join(os.Args[1:], " "))
}
