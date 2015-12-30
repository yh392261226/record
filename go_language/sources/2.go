package main
import (
    "fmt"
)
/**
 * 定义常量
 * 主要使用const 关键字来定义常量
 * 常量最好是大写  习惯好一点
 */
 func main() {
     const WORD string = "This is a const string"
     newword := "Hi, " + WORD
     fmt.Println(newword)
 }
