package main

/**
 * 根据为结构增加方法的知识，尝试声明一个底层类型为int的类型，并实现调用某个方法就递增100
 * 例如：a := 0,调用a.Increase()之后a从0变为100
 */

import (
	"fmt"
)

type TZ int

func (tz *TZ) Increase(num int) {
	*tz += TZ(num * 100)
}

func main() {
	var a TZ
	a.Increase(100)
	fmt.Println(a)
}
