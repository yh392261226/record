package main

import (
    "fmt"
)

/**
 * 数值溢出
 * 超出高位的bit位部分将被丢弃。 如果原始的数值是有符号的，而最左边的bit为1的话 那么结果可能是负数。
 * 运用整形的时候  需要注意取值范围 否则数值溢出 结果就不是自己想要的了
 */
func main() {
    var u uint8 = 255
    fmt.Println(u, u + 1, u * u) // 255 0 1
    
    var i int8 = 127
    fmt.Println(i, i + 1, i * i) // 127 -128 1
}