package main
import (
    "fmt"
)
/**
 * goto语句
 * 语法： goto LABLE
 *       LABLE: 语句块
 */
 func main() {
     var a int = 10
     LOOP: for a < 20 {
         if a == 15 {
             a += 1
             goto LOOP
         }
         fmt.Println(a)
         a++
     }
 }
