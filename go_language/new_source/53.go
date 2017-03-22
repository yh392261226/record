package main

/**
 * * 6：只有当接口存储的类型和对象都为nil时，接口才等于nil。
 */

import (
	"fmt"
)

//空接口
type empty interface {
}

type USB interface {
	Name() string
	Connecter
}

type Connecter interface {
	Connect()
}

type PhoneConnecter struct {
	name string
}

func (pc PhoneConnecter) Name() string {
	return pc.name
}

func (pc PhoneConnecter) Connect() {
	fmt.Println("Connected:", pc.name)
}

func main() {
	var a interface{}
	fmt.Println(a == nil) //true

	var p *int = nil //新指针p 是nil空
	a = p
	fmt.Println(a == nil) //false
}

func Disconnect(usb interface{}) {
	//switch结构判断
	switch v := usb.(type) {
	case PhoneConnecter:
		fmt.Println("Disconnected:", v.name)
	default:
		fmt.Println("Unknow device.")
	}
	return
	//或
	//if结构判断
	if pc, ok := usb.(PhoneConnecter); ok {
		fmt.Println("Disconnected:", pc.name)
		return
	}
	fmt.Println("Unknow device.")
}
