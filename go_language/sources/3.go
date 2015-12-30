package main
import (
    "fmt"
)
/**
 * for循环
 * 四个参数   第四个还不知道怎么用
 * 开始 结束条件 步阶 随机数
 *
 */
 func main() {
     var b int = 15
     var a int
     numbers := [6] int {1,2,3,5}
     for a := 0; a < 10; a++ {
         fmt.Println(a)
     }
     fmt.Println("---------------------------------")
     for a < b {
         a++
         fmt.Println(a)
     }
     fmt.Println("---------------------------------")
     for i, x := range numbers{
         fmt.Printf("%d %d\n", x, i)
     }
 }
