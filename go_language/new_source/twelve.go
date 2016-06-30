package main

/**
 * i++ i--
 * 这些都是语句 不能做赋值操作
 */
import (
    "fmt"
)

func main() {
    a := 1
    fmt.Println(a)
    a++
    fmt.Println(a)
}
