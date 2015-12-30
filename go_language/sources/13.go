package main
import (
    "fmt"
    "runtime"
)
/**
 * 这里展示一下并发并行的例子  多次执行 结果不一样
 * 
 */
var quit chan int = make(chan int)

func loop(id int) {
    for i := 0; i < 10; i++ {
        fmt.Println("%d", id)
    }
    quit <- 0
}

func main() {
    runtime.GOMAXPROCS(2)
    for i := 0; i < 3; i++ {
        go loop(i)
    }
    for i := 0; i < 3; i++ {
        <-quit
    }
}
