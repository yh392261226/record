package tempconv

import (
    "fmt"
)

//定义类型
type Celsius float64
type Fahrenheit float64

//定义常量
const(
    AbsoluteZeroC Celsius = -273.15 //绝对零度
    FreezingC     Celsius = 0 //结冰点
    BoilingC      Celsius = 100 //沸点
)

//返回摄氏度的字符串
func (c Celsius) String() string {
    return fmt.Sprintf("%g°C", c)
}

//返回华氏度的字符串
func (f Fahrenheit) String() string {
    return fmt.Sprintf("%g°F", f)
}