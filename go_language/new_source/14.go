package main
/**
 * go语言中循环语句只有一个for循环语句
 * for循环的功能很强大 有三种形式：
 * 1 初始化和步进表达式可以是多个值
 * 2 条件语句每次循环都会被重新检查，因此不建议在条件语句中使用函数， 尽量提前计算好条件并以变量或常量代替
 * 3 左大括号必须和条件语句在同一行
 */
 import (
    "fmt"
 )

 func main() {
     i := 1
    for { //无限循环
        if i > 3 {
            break
        }
        i++
        fmt.Println(i)
    }

    //for条件表达式
    for j:=1; j<3; j++ {
        fmt.Println(j)
    }

    //for自带的表达式
    k:=3
    for k < 4 {
        k++
        fmt.Println(k)
    }
 }
