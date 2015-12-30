package main
import (
    "fmt"
)
/**
 * for循环的集中写法
 *
 */
 func main() {
     i := 1
     for i <= 3 {
         fmt.Println(i)
         i += 1
     }

     for j := 7; j <= 9; j++ {
         fmt.Println(j)
     }

     for {
         fmt.Println("this is a test")
         break
     }
 }
