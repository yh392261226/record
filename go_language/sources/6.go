package main
import (
    "fmt"
)
/**
 * 自定义函数
 * 函数关键字 函数名      (参数集)   [返回值类型]
 * func function_name( [parameter list]) [return_types]
 * {
 *     代码块
 *     return 返回值
 * }
 *
 *
 */
func main() {
    var a int = 100
    var b int =200
    var ret int
    ret = max(a, b)
    fmt.Println(ret)
}

/**
 * 比较两个数
 * 返回最大值
 */
func max(num1, num2 int) int {
    var result int
    if (num1 > num2) {
        result = num1
    } else {
        result = num2
    }
    return result
}
