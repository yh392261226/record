package main

/**
* URL：http://study.163.com/course/courseLearn.htm?courseId=306002#/learn/video?lessonId=421023&courseId=306002
* 第12课时
* 时间：22：10
* 接口interface

* 1：接口是一个或多个方法签名的集合。
* 2：只要某个类型拥有该接口的所有方法签名，即算实现该接口，
无需显示声明实现了那个接口，这成为Structural Typing。
* 3：接口只有方法声明，没有实现，没有数据字段。
* 4：接口可以匿名嵌入其他接口，或嵌入到结构中。
* 5：将对象赋值给接口时，会发生拷贝，二接口内部存储的是只想这个复制品的指针，即无法修改复制品的状态，也无法获取指针。
* 6：只有当接口存储的类型和对象都为nil时，接口才等于nil。
* 7：接口调用不会做receiver的自动转换。
* 8：接口同样支持匿名字段方法。
* 9：接口也可实现类似OOP中的多态。
* 10：空接口可以作为任何类型数据的容器。
*/

import (
	"fmt"
)

func main() {
	fmt.Println("interface")
	return
}
