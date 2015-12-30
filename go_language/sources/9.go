package main
import (
    "fmt"
    "math"
)
/**
 *
 *Go编程语言支持特殊类型的函数调用的方法。在方法声明的语法中，“接收器”的存在是为了表示容器中的函数。该接收器可用于通过调用函数“.”运算符。下面是一个例子：
 *
 */
 func main() {
     circle := Circle{x:0, y:0, radius:5}
     fmt.Println(circle.area())
 }

 type Circle struct {
    x, y, radius float64
 }

 func(circle Circle) area() float64 {
    return math.Pi * circle.radius * circle.radius
 }
