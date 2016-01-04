package main

/**
 * 定义变量
 *=======================
 * 定义变量基本两种写法
 * var 变量名 变量类型 [=值]
 * var 变量名 变量类型
 * 变量名 = 值
 *-----------------------
 * 或直接使用
 * 变量名 := 值   这种方式只能在函数内使用
 *
 * 注释的方式在代码里都有了  不用单独写了
 *  字符串连接符 是 +
 *  字符串_ 是一个特殊的存在    所有赋值给_的 都将被丢弃 就是不存在的意思
 * 空 用nil表示 相当于php中的null
 */
import (
	"fmt"
)

func main() {

	//变量赋值
	var mynum int = 999999999 //指定类型并直接赋值
	fmt.Println(mynum)
	var mynum1 int     //先指定类型
	mynum1 = 999999999 //再赋值
	fmt.Println(mynum1)
	mynum2 := 999999999 //不指定类型直接赋值 让程序自己判断类型
	fmt.Println(mynum2)
	var aa, bb = 3, "string" //不指定类型 声明并赋值 让程序自己判断类型
	fmt.Println(aa)
	fmt.Println(bb)
	fmt.Println("a is of type %T", aa)
	fmt.Println("a is of type %T", bb)

	//同时定义多个变量
	var name1, name2, name3 int = 1, 2, 3
	// name1, name2, name3 := 1, 2, 3
	fmt.Println(name1)
	fmt.Println(name2)
	fmt.Println(name3)

	//整形
	var number int
	number = 10
	num := 10
	fmt.Println(number)
	fmt.Println(num)
	//字符串
	var str string
	str = "This is a test line !"
	s := "This is another test line!"
	fmt.Println(str)
	fmt.Println(s)
	//布尔值
	var buer bool
	buer = true
	b := false
	fmt.Println(buer)
	fmt.Println(b)
	//浮点型
	var floatnum float64 //或者float32
	floatnum = 1.101
	floatn := 1.102
	fmt.Println(floatnum)
	fmt.Println(floatn)
	//字节型
	var bytes byte
	bytes = 255         //最大支持到255
	byt := -99990101010 //负数无限大啊
	fmt.Println(bytes)
	fmt.Println(byt)
	//多个变量声明
	var (
		nums  int
		text  string
		check bool
	)
	nums = 10
	text = "test string"
	check = false
	fmt.Println(nums)
	fmt.Println(text)
	fmt.Println(check)
	//多个相同类型的变量 赋值
	xx, yy, zz := 11, 22, 33
	fmt.Println(xx)
	fmt.Println(yy)
	fmt.Println(zz)
	//多个相同类型的变量 赋值   有不同类型的时候 会自动给踢出去
	var i, j, k, l int
	i = 3
	j = 2 //true
	k = 1
	l = 0
	fmt.Println(i)
	fmt.Println(j)
	fmt.Println(k)
	fmt.Println(l)
	xxx, yyy, zzz := true, false, 1
	fmt.Println(zzz)
	fmt.Println(xxx)
	fmt.Println(yyy)
	//特殊变量 _  任何给它的赋值都会被丢弃
	_, x := 33, 22
	//fmt.Println(_)   //会报错的
	fmt.Println(x)

	//字符串特殊情况
	a := "this is a test"
	c := []byte(a)
	c[0] = 'c'
	d := string(c)
	fmt.Println(d)

}
