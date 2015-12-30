package main
import (
    "fmt"
    "math" //数学函数库
)
/**
 * 引入匿名函数及数学函数库
 *
 * 匿名函数与非匿名函数
 *
 */
func main() {
    getSquareRoot := func(x float64) float64 {
        return math.Sqrt(x)
    }

    fmt.Println(getSquareRoot(9))

    var result float64 = getSquare(9)
    fmt.Println(result)
}


func getSquare(x float64) float64 {
    return math.Sqrt(x)
}
