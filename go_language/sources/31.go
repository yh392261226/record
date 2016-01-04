package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"strings"
)

/**
 * 27-30.go 都是以流形式处理
 * 现在以一次性读取进内存进行处理  速度要远高于流形式处理
 * 当前脚本仍然是取交集
 * 使用方法：go run 31.go test1 test2
 */

func main() {
	counts := make(map[string]int)
	for _, filename := range os.Args[1:] {
		data, err := ioutil.ReadFile(filename)
		if err != nil {
			fmt.Fprintf(os.Stderr, "dup3:%v\n", err)
			continue
		}

		for _, line := range strings.Split(string(data), "\n") {
			counts[line]++
		}
	}

	fmt.Println(counts)

	for line, n := range counts {
		if n > 1 {
			fmt.Printf("%d\t%s\n", n, line)
		}
	}
}
