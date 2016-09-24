package main

/**
 * defer 的执行方式类似其他语言中的析构函数, 在函数体执行结束后按照调用顺序的相反顺序逐个执行
 * 即使函数发生严重错误也会执行
 * 支持匿名函数的调用
 * 常用语资源清理、文件关闭、解锁及记录时间等操作
 * 通过匿名函数配合可以在return之后修改函数计算结果
 * 如果函数体内某个变量作为defer时匿名函数的参数，则在定义defer时就已经获得了拷贝，否则是引用某个变量的地址
 *
 * Go没有异常机制，但是有panic/recover模式来处理错误
 * Panic可以做任何地方引发，但是recover只有在defer调用的函数中有效
 */
import (
	"fmt"
)

func main() {
	fmt.Println("------------------------------------")
	A()
	fmt.Println("------------------------------------")
	B()
}

func A() { //记住它会逆向反顺序的执行
	for i := 0; i < 3; i++ {
		defer fmt.Println(i)
	}
}

func B() {
	for i := 0; i < 3; i++ {
		defer func() {
			fmt.Println(i)
		}()
	}
}
