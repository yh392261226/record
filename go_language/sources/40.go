package tempconv
/**
 * 创建自己的包文件
 * 
 *
 */
//摄氏度转华氏度
func CToF(c Celsius) Fahrenheit {return Fahrenheit(c * 9 / 5 + 32)}
//华氏度转摄氏度
func FToC(f Fahrenheit) Celsius {return Celsius((f - 32) * 5 / 9)}