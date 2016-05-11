package main //当前程序的包名称

import ( //导入其他的包
	std "fmt"
	//另外的写法 很省事 但是查找很麻烦
	. "fmt"
)

const PI = 3.14 //常量

var name = "gopher" //全局变量

type newType int //一般类型的声明

type gopher struct{} //结构的声明

type golang interface{} //接口声明

func main() {
	std.Println("Hello world! ")
	//fmt.Println("test") 这个是报错的
	Println("test")
}
