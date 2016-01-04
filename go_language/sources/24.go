package main

import (
	"fmt"
  "os"
)

/**
* 命令行参数:
*			os这个包提供了与系统交互的一些函数和变量它是跨平台的，运行时程序的命令行参数可以通过os包中的Args变量来获取，当在os包外使用该变量时，需要用os.Args来访问  类似shell脚本 即0是当前脚本  后面的才是参数
*			os.Args 变量是一个字符串(string) 的slice【类似于python的切片 也是go语言中的一种基本类型 是元素序列的数组, 访问方式：s[i] 的下标方式来获取值】
*           长度可以用len(s)获取
*
*			go语言中 索引数组形式采用左右关闭区间，包括m~n的第一个元素,但不包括最后一个元素 即从m(含m) ~ n（不含n）的值   例如: a = [1,2,3,4,5] ; a[0:3] 就是[1,2,3] 并不包含4
*     
*     如果想使用所有除命令本身的参数 os.Args[1:len(os.Args)]   也可以写成 os.Args[1:]
* 使用方法：
*      go run 24.go 1 2 3 4 5 
*
 */
func main() {
  var s, sep string
  for i := 1; i < len(os.Args); i++ {
    s += sep + os.Args[i]
    sep = " "
  }
  fmt.Println(s)
}

