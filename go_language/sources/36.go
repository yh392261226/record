package main

import (
	"fmt"
	"log"
	"net/http"
	"sync"
)

/**
 * 记录访问次数
 * 如果访问http://localhost:8000/count 就会显示共被访问了多少次
 * 其他的访问 都是走的handler 只有count的访问会走counter
 * 可以做记录器
 * 使用方法：go run 36.go 然后去浏览器里访问http://localhost:8000
 */

var mu sync.Mutex
var count int

func main() {
	http.HandleFunc("/", handler)
	http.HandleFunc("/count", counter)
	log.Fatal(http.ListenAndServe("localhost:8000", nil))
}

func handler(w http.ResponseWriter, r *http.Request) {
	mu.Lock()
	count++
	mu.Unlock()
	fmt.Fprintf(w, "URL.Path = %q\n", r.URL.Path)
}

func counter(w http.ResponseWriter, r *http.Request) {
	mu.Lock()
	fmt.Fprintf(w, "Count %d\n", count)
	mu.Unlock()
}
