package main

/**
 * 接口调用
 *		嵌入接口
 * 	go语言不存在继承的概念
 */

import (
	"fmt"
)

type USB interface {
	Name() string
	Connect()
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
	fmt.Println("Connect:", pc.name)
}

func main() {
	var a USB
	a = PhoneConnecter{"PhoneConnecter"}
	//或者写成
	// a := PhoneConnecter{"PhoneConnecter"}
	a.Connect()
	Disconnect(a)
}

func Disconnect(usb USB) {
	if pc, ok := usb.(PhoneConnecter); ok {
		fmt.Println("Disconnected:", pc.name)
		return
	}
	fmt.Println("Unknown Decive.")
}
