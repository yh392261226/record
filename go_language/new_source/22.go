package main
/**
 * map
 * 类似其他语言中的hash表或者字典， 以key-value形式存储数据
 * key必须是支持== 或!= 比较运算的类型，不可以是函数，map或者slice
 * map查找比现行搜索块很多，但比使用索引访问数据的类型慢100倍
 * map 使用make()创建， 支持:= 这种简写方法

 * make([keyType]valueType, cap) cap表示容量，可省略
 * 超出容量时会自动扩充容量，但尽量提供一个合理的初始值
 * 使用len()获取元素个数

 * 键值对不存在时自动添加，使用delete()删除某键值对
 * 使用for range 对map和slice进行迭代操作
 *
 */
import (
    "fmt"
)

func main() {
    /**
     * 以下的三个变量m n o 的声明方式都是可行的  但是第二种貌似会报warnning
     *
     */
    var m map[int]string
    m = map[int]string{}
    fmt.Println(m)

    var n map[int]string = make(map[int]string)
    fmt.Println(n)

    o := make(map[int]string)
    fmt.Println(o)

    /**
     * 下面的例子是赋值
     *
     */
    t := make(map[int]string)
    t[1] = "OK"
    fmt.Println(t)
    a := t[1] //将t的下标是1的元素赋值给a
    fmt.Println(a) //输出结果是OK
    //如果t[1] 是空的 或者不存在 就返回空
    delete(t, 1)
    fmt.Println(t) //结果是空
    fmt.Println(a) //结果是OK 并不会因为原数组被删除而改变

    /**
     * 多维数组
     *
     */
    var mm map[int]map[int]string
    mm = make(map[int]map[int]string)
    mm[1] = make(map[int]string)
    mm[1][1] = "test"
    aa := mm[1][1]
    fmt.Println(aa)
    mm[2] = make(map[int]string)
    bb := mm[2][1]
    fmt.Println(bb)

    /**
     * 当map的子map未被初始化的时候会报错， 那么就需要动态的为这个map来初始化
     *** 每一级的map必须要单独的初始化 ***
     */
    cc, ok := mm[3][1] //这里利用go语言的多返回值， 第二个值的结果是布尔值，如果是false的话 说明未被初始化
    if !ok {
        mm[3] = make(map[int]string) //自动初始化
    }
    mm[3][1] = "test2" //赋值
    cc = mm[3][1]   //赋值
    fmt.Println(cc) //打印结果
}
