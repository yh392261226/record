package main

/**
 * 终止程序 及 让程序回转回来
 * 即先杀死它(panic) 再让它活过来(recover)
 */
import (
	"fmt"
)

func main() {
	A()
	B()
	C()
}

func A() {
	fmt.Println("Func A")
}

func B() {
	defer func() { //recover函数需要在panic函数之前 否则就不会往下执行了
		if err := recover(); err != nil {
			fmt.Println("Recover in B")
		}
	}()

	panic("Panic in B") //直接终止执行了
}

func C() {
	fmt.Println("Func C")
}
