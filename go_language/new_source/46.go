package main

import (
    "fmt"
)

type TZ int

func (tz *TZ) Increase(num int) {
    *tz += TZ(num) //强制类型转换 否则会报类型不匹配
}

func main() {
    var a TZ
    a.Increase(100)
    fmt.Println(a)
}
