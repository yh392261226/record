package tempconv
import (
    "fmt"
)
/**
 * 自己的包  
 *  包含变量 声明 常量 含有方法
 *
 */
type Celsius float64
type Fahrenheit float64

const (
    AbsoluteZeroC Celsius = -273.15 //绝对0度
    FreezingC     Celsius = 0       //结冰点
    BoilingC      Celsius = 100     //沸点
)
//摄氏度
func (c Celsius) String() string { return fmt.Sprintf("%g°C", c)}
//华氏度
func (f Fahrenheit) String() string{ return fmt.Sprintf("%g°F", f)}
//主函数
// func main() {
    
// }