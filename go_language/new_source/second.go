package main
import(
  "fmt"
)
/**
 * Go的基本类型
   布尔型： bool
      长度：2字节
      取值范围：-32768 ~ 32767 或者 0 ~ 65535
      注意事项：不可以用数字代表true或false

   整型：int/uint
      根据运行平台可能为32或64位

   8位整型：int8/uint8
      长度：1字节
      取值范围：-128 ~ 127 或 0 ~ 255

   字节型：byte(uint8的别名)

   16位整型：int16/uint16
      长度：2字节
      取值范围：-32768 ~ 32767 或 0 ~ 65535

   32位整型：int32 (rune别名)/unit32
      长度：4字节
      取值范围：-2^32 或 2 ~ 2 ^32 或 2-1/0 ~ 2^32-1

   64位整型：int64/uint64
      长度：8字节
      取值范围：-2^64/2~2^64/2-1/0~2^64-1

   浮点型：float32/float64
      长度：4/8字节
      小数位：精确到小数点的后7位(32位)/小数点后15位(64位)小数位

   负数：complex64/complex128
      长度：8/16字节
      足够保存指针的32位或64位整数型：uintptr

   其他类型：
      array、struct、string

   引用类型：
      slice(数组的高层封装)、map、chan(并发类型 必不可少)

   接口类型：inteface

   函数类型：func

   类型零值：
    零值并不等于空值，而是当变量被声明为某种类型后的默认值，
    通常情况下值类型的默认值为0，bool为false，string为空字符串。


 */
func main() {
  var a int
  fmt.Println(a)
  var b bool
  fmt.Println(b)
  var c string
  fmt.Println(c)
}
