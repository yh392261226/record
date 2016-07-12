package main

/**
 * 数组 
 * 定义数组的格式：var<varName>[n]<type>, n>=0
 * 数组长度也是类型的一部分， 因此具有不同长度的数组为不同类型
 * 注意区分指向数组的指针和指针数组
 * 数组在go中为值类型 (即go的数组不是引用 而是复制出来一份做操作  只有slice才是引用)
 * 数组之间可以使用== 或!=进行比较， 但不可以用<或>
 * 可以使用new来创建数组，此方法返回一个指向数组的指针
 * go支持多维数组
 */
import (
  "fmt"
)


func main() {
	a := [20]int{19:1} //不指定前19个值 默认是0  第20个值是1
  	fmt.Println(a)
  	b := [...]int{1,2,3,4,5} //用...来虚定义数组个数  go会自动计算
  	fmt.Println(b)
  	//索引数组
  	c := [...]int{0:1, 1:2, 2:3, 3:4}
  	fmt.Println(c)

	d := [...]int{99: 1}
	var p *[100]int = &d
	fmt.Println(p)

	//指针 访问返回内存地址
	x, y := 1, 2
	e := [...]*int{&x, &y}
	fmt.Println(e) //返回结果是两个内存的地址

	//数组比较
    f := [2]int{1,2}
    g := [2]int{1,3}
	fmt.Println(f == g) //返回false  go的数组比较很严格 不同的类型也不能比较

    //new 创建数组
    h := new([10]int)
    fmt.Println(h) //返回指向数组的指针

    //赋值
    i := [10]int{}
    i[1] = 2 //单个元素赋值
    fmt.Println(i) //返回数组
    j := new([10]int)
    j[1] = 2 //单个元素赋值
    fmt.Println(j) //返回数组指针

    //多维数组
    k := [2][3]int{ //在有两个值的二维数组 中每个子数组有三个值
        {1,2}, //如果不足设定 就0补位
        {4,5,6}} //这里的结尾需要注意，不能让大括号单起一行 否则报错
    fmt.Println(k)
    l := [2][3]int{
        {1:1},
        {2:2}}
    fmt.Println(l)
    //非顶级的元素数组不能用...来定义数组长度
    m := [...][3]int{
        {1:1},
        {2:2}}
    fmt.Println(m)

    arr := [...]int{2,4,1,9,5,6}
    fmt.Println(arr)

    //go版的冒泡排序
    acount := len(arr)
    for o := 0; o < acount; o++ {
        for p := o + 1; p < acount; p++ {
            if arr[o] < arr[p] {
                temp := arr[o]
                arr[o] = arr[p]
                arr[p] = temp
            }
        }
    }
    fmt.Println(arr)
}

