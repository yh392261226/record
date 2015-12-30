package main
import (
    "fmt"
    // "math"
)
/**
 * 函数闭包
 * 难道这才是匿名函数？？？
 *
 */
func main() {
    nextNumber := getSequence()
    fmt.Println(nextNumber())
    fmt.Println(nextNumber())
    fmt.Println(nextNumber())

    nextNumber1 := getSequence()
    fmt.Println(nextNumber1())
    fmt.Println(nextNumber1())
}

func getSequence() func() int {
    i := 0
    return func() int {
        i += 1
        return i
    }
}
