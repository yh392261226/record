package main

/**
 * 接口复制品
 * 接口只是拿到一个对象的拷贝的指针 修改后对原对象并不影响
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
	pc := PhoneConnecter{"PhoneConnecter"}
	var a Connecter
	a = Connecter(pc)
	a.Connect()

	pc.name = "pc"
	a.Connect()
}

func Disconnect(usb USB) {
	if pc, ok := usb.(PhoneConnecter); ok {
		fmt.Println("Disconnected:", pc.name)
		return
	}
	fmt.Println("Unknown Decive.")
}
