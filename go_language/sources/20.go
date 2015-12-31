package main

/**
 * iota 枚举类型
 *
 *
 */

 const(
     x = iota //x == 0
     y = iota //y == 1
     z = iota //z == 2
     w //常量声明省略值时， 默认和前一个值的字面相同，这里隐式说明w = iota 因此w == 3
 )

 const v = iota //每遇到一个const关键字， iota就会重置， 所以此时的v == 0

 const (
     e, f, g = iota, iota, iota // e==0 f==0 g==0 iota在同一行值就相同
 )

 const (
     a = iota //a == 0
     b = "B"
     c = iota //c == 2
     d, e, f = iota, iota, iota //d == 3 e == 3 f == 3
     g //g == 4
 )

