package main

import (
    "fmt"
)

/**
 * 这个例子演示如何使用位操作解释uint8类型值的8个独立的bit位。
 * 它使用Printf函数的%b参数打印二进制格式的数字；其中%08b中08表示打印至少8个字符宽度，不足的前缀部分用0填充。
 *
 */

 func main() {
    var x uint8 = 1<<1 | 1<<5
    var y uint8 = 1<<1 | 1<<2

    fmt.Printf("%08b\n", x) //00100010, the set {1, 5}
    fmt.Printf("%08b\n", y) //00000110, the set {1, 2}

    fmt.Printf("%08b\n", x&y) //00000010, the intersection {1}
    fmt.Printf("%08b\n", x|y) //00000010, the union {1, 2, 5}
    fmt.Printf("%08b\n", x^y) //00100100, the symmetric difference {2, 5}
    fmt.Printf("%08b\n", x&^y) //00100000, the difference {5}

    for i:= uint(0); i < 8; i++ {
        if x&(1<<i) != 0 { //membership test
            fmt.Println(i) //1, 5
        }
    }

    fmt.Printf("%08b\n", x<<1) //01000100, the set {2, 6}
    fmt.Printf("%08b\n", x>>1) //00010001, the set {0, 4}
 }
