package main

/**
 * 参考网址：http://study.163.com/course/courseLearn.htm?courseId=306002#/learn/video?lessonId=421018&courseId=306002
 * slice 切片
 * 其本身并不是数组， 它指向底层的数组
 * 作为变长数组的替代方案， 可以关联底层数组的局部或全部
 * 为引用类型
 * 可以直接创建或从底层数组获取生成
 * 使用len()获取元素个数， cap()获取容量
 * 一般使用make() 创建
 * 如果多个slice指向相同底层数组，其中一个的值改变会影响全部
 * make([]Type, len, cap)
 * 其中cap可以省略，则和len的值相同
 * len表示存数的元素个数，cap表示容量
 */
import (
	"fmt"
)

func main() {
	var s1 []int
	fmt.Println(s1)

	s2 := [10]int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
	fmt.Println(s2)
	s22 := s2[9]
	fmt.Println(s22)      //打印的是第九个元素 得到0
	fmt.Println(s2[5:10]) //打印从5-10的元素 []中的值是包含起始索引 不包含终止索引的 即5 6 7 8 9
	s220 := s2[0:4]       //打印从开始到4的元素
	fmt.Println(s220)
	s221 := s2[:4] //等同于 s2[0:4]
	fmt.Println(s221)
	s222 := s2[3:len(s2)] //打印从3-最后的元素
	fmt.Println(s222)
	s223 := s2[3:] //与s2[s:len(s2)]相同
	fmt.Println(s223)

	//刚到slice...
	s3 := make([]int, 3, 10) //定义一个初始值为10的slice  第三个参数指的是占内存的区块数 连续的 每次元素个数超过内存块的话每次增加10块  go很高明 为了提升效率 因为每次操作内存块很麻烦
	//最大容量可以不设置 默认就认为是已有的个数长度
	fmt.Println(len(s3), cap(s3)) //打印个数及容量

	s4 := []byte{'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k'}
	s44 := s4[2:5]
	fmt.Println(s44)         //返回assc码
	fmt.Println(string(s44)) //转换一下就可以返回正常的cde了

}
