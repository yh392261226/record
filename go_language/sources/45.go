package main

import (
    "fmt"
    "os"
    "log"
)
/**
 * init 构造函数  最先执行
 * 据说这种方式是错误的  但是打印没有问题
 * init 被先解析了
 */
var cwd string

func init() {
    cwd, err := os.Getwd() //NOTE: wrong! //教程里说这行是错误的  可是我运行没有问题啊？？？
    if err != nil {
        log.Fatalf("os.Getwd failed: %v", err)
    }
    log.Printf("Working directory = %s", cwd)
}

func main() {
    fmt.Println("this is a 闹心的事啊")
    fmt.Println(cwd)
}
