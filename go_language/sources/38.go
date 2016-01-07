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

func compare() {
	var c Celsius
	var f Fahrenheit
	fmt.Println(c == 0)          //true
	fmt.Println(f >= 0)          //true
	fmt.Println(c == Celsius(f)) //true
    // fmt.Println(c == f)          //compile error: type mismatch
}

func (c Celsius) String() string {return fmt.Sprintf("%g°C", c)}

func main() {
	fmt.Printf("%g\n", BoilingC-FreezingC)
	boilingF := CToF(BoilingC)
	fmt.Printf("%g\n", boilingF-CToF(FreezingC))
	//fmt.Printf("%g\n", boilingF-FreezingC)   // 报错  invalid operation: boilingF - FreezingC (mismatched types Fahrenheit and Celsius)
    //调用函数compare()
    compare()
    
    c := FToC(212.0)
    fmt.Println(c.String()) // 字符串的100°C
    fmt.Printf("%v\n", c)   // 字符串的100°C ； no need to call String explicitly 不需要调用字符串转义函数 String()
    fmt.Printf("%s\n", c)   // 字符串的100°C
    fmt.Printf("c")         // 字符串的100°C
    fmt.Printf("%g\n", c)   // c100; does not call String 没有调用字符串转义函数 String()
    fmt.Println(float64(c)) // 64位浮点的100; does not call String 没有调用字符串转义函数 String()
}
