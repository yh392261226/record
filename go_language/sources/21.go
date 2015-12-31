package main

import (
	"fmt"
)

/**
 * 不知道多大的动态数组 slice
 * slice 是引用类型   所以当引用改变其中的元素的值时， 其他的所有引用都会改变该值。
 * 测试发现  字节会默认转成数值 显示
 *
 * 有用的内置函数
 * len 获取slice的长度
 * cap 获取slice的最大容量
 * append 想slice里追加一个或多个元素， 然后返回一个和slice一样类型的slice
 * copy 函数 conpy从源slice的src中复制元素到目标dst 并返回复制的个数
 */
func main() {
	var fslice []int
	myslice := []byte{'a', 'b', 'c', 'd'}
	var ar = [10]byte{'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j'}

	//声明多个含有byte的slice数组
	var a, b []byte
	a = ar[2:5]
	b = ar[3:5]
	fmt.Println(fslice)
	fmt.Println(myslice)
	fmt.Println(ar)
	fmt.Println(a)
	fmt.Println(b)
}
