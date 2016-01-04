package main

import (
	"fmt"
	"log"
	"net/http"
)

/**
 * web服务
 * 监听8000端口 并输出当前访问的路径
 * 使用方法：go run 35.go   然后到浏览器里打开http://localhost:8000/
 */
func main() {
	http.HandleFunc("/", handler)
	log.Fatal(http.ListenAndServe("localhost:8000", nil))
}

func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "URL.Path = %q\n", r.URL.Path)
}
