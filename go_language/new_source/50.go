package main

/**
 * 接口转换问题。会报错
 */

import "fmt"

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

type TVConnecter struct {
	name string
}

func (pc PhoneConnecter) Connect() {
	fmt.Println("Connected:", pc.name)
}

func (tv TVConnecter) Connect() {
	fmt.Println("Connected:", tv.name)
}

func main() {
	pc := PhoneConnecter{"PhoneConnecter"}
	var a Connecter
	a = Connecter(pc)
	a.Connect()

	tv := TVConnecter{"TVConnecter"}
	var b USB
	b = USB(tv)
	b.Connect()
}

func Disconnect(usb interface{}) {
	switch v := usb.(type) {
	case PhoneConnecter:
		fmt.Println("Disconnected:", v.name)
	default:
		fmt.Println("Unknow device.")
	}
}
