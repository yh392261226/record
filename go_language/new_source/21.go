package main

import (
	"fmt"
)

/**
 * Reslice
 * 即从一个slice中获取另一个slice
 * Reslice 时索引以被slice的切片为准
 * 索引不可以超过被slice的切片的容量cap()的值
 * 索引越界不会导致底层数组的重新分配而是引发错误
 *
 * Append
 * 可以在slice尾部追加元素
 * 可以将一个slice追加到另一个slice尾部
 * 如果最终长度未超过追加到的slice的容量，则返回原始slice
 * 如果超过追加到的slice的容量则将重新分配数组并拷贝原始数据
 *
 * Copy
 *
 */

func main() {
	//Reslice
	a := []byte{'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n'}
	sa := a[2:5]                  //实际上sa的长度仍旧是从3到a的总长度
	fmt.Println(len(sa), cap(sa)) //结果是3.12 3个元素 12个的容量
	//fmt.Println(sa[12:22])        //会报错的  因为sa的容量为9个 从3-12 查过就报错 即索引越界
	sb := sa[1:3]
	fmt.Println(string(sa))
	fmt.Println(string(sb))
	fmt.Println(string(sa[3:5])) //得出的是fg 相当于去找源数组了

	//Append
	s1 := make([]int, 3, 6)
	fmt.Printf("%p\n", s1)
	s1 = append(s1, 4, 5, 6)
	fmt.Printf("%v %p\n", s1, s1)
	s1 = append(s1, 1, 2, 3)
	fmt.Printf("%v %p\n", s1, s1)

	b := []int{1, 2, 3, 4, 5}
	b1 := b[2:5]
	b2 := b[1:3]
	fmt.Println(b1, b2)
	b2 = append(b2, 1, 2, 3, 4, 5, 6, 7, 8, 8, 8, 8, 8, 8, 8)
	b1[0] = 9 //数组指向指针
	fmt.Println(b1, b2)

	//Copy
	c1 := []int{1, 2, 3, 4, 5, 6}
	c2 := []int{7, 8, 9}
	copy(c1, c2) //c2会覆盖c1中的同键的值
	//copy(c2, c1) //复制c2到c1    	//第二个长于第一个 以第一个为准 第二个短于第一个 只覆盖第二个那么多个
	//copy(c1[1:2], c2[2:3])  		//指定位置的复制
	fmt.Println(c1)
}
