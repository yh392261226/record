package main

import (
	"fmt"
)

type T int //其实任意类型都可以  因为方法会自动转换的

func main() {
	var a T
	a.Print()      //Method Value
	(*T).Print(&a) //Method Expression
}

func (a *T) Print() {
	fmt.Println("T")
}
