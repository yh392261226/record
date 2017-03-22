package main

/**
 * select
 * 可以处理一个或多个channel的发送与接收
 * 同时有多个可用的channel时安随机顺序处理
 * 空的select来阻塞main函数
 *
 */

import (
	"fmt"
	"time"
)

func main() {
	T1()
	T2()
	T3()
}

//select的接收
func T1() {
	c := make(chan int)
	go func() {
		for v := range c {
			fmt.Println(v)
		}
	}()

	for i := 0; i < 10; i++ {
		select {
		case c <- 0:
		case c <- 1:
		}
	}
}

//select阻塞main函数
func T2() {
	select {}
}

//select 超时
func T3() {
	c := make(chan bool)
	select {
	case v := <-c:
		fmt.Println(v)
	case <-time.After(3 * time.Second):
		fmt.Println("Timeout")
	}
}
