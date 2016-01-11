package main

import (
    "fmt"
    "os"
    "log"
)

/**
 * init 构造函数  最先执行
 *
 *
 */
var cwd string

func init() {
    var err error
    cwd, err = os.Getwd()
    if err != nil {
        log.Fatalf("os.Getwd failed: %v", err)
    }
}

func main() {
    fmt.Println("this is a 闹心的事啊")
    fmt.Println(cwd)
}
