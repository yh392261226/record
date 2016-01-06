package main

import (
	"fmt"
)

/**
 * 定义类型
 * type 类型名称  底层类型
 * 研究不是很明白,感觉就像是定义一种数据类型  然后使用 数据类型不同还不能比较或做数学操作
 */

type Celsius float64    //摄氏度
type Fahrenheit float64 //华氏度

const (
	AbsoluteZeroC Celsius = -273.15 //绝对0度
	FreezingC     Celsius = 0       //结冰点温度
	BoilingC      Celsius = 100     //沸水点温度
)

func CToF(c Celsius) Fahrenheit {
	return Fahrenheit(c*9/5 + 32)
}

func FToC(f Fahrenheit) Celsius {
	return Celsius((f - 32) * 5 / 9)
}

func main() {
	fmt.Printf("%g\n", BoilingC-FreezingC)
	boilingF := CToF(BoilingC)
	fmt.Printf("%g\n", boilingF-CToF(FreezingC))
	//fmt.Printf("%g\n", boilingF-FreezingC)   // 报错  invalid operation: boilingF - FreezingC (mismatched types Fahrenheit and Celsius)

}

func compare() {
	var c Celsius
	var f Fahrenheit
	fmt.Println(c == 0)          //true
	fmt.Println(f >= 0)          //true
	fmt.Println(c == f)          //compile error: type mismatch
	fmt.Println(c == Celsius(f)) //true
}
