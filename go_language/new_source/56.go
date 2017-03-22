package main

/**
 * 并发 concurrency
 * 	很多人都是冲着Go大肆宣扬的高并发二忍不住跃跃欲试，但其实从源码的解析来看goroutine只是由官方实现的超级“线程池”而已。
 *不过话说回来，每个实例4-5kb的栈内存占用和忧郁实现机制而大幅减少的创建和销毁开销，是制造Go号称的高并发的根本原因，另外goroutine的简单易用，
 *也在语言层面上给予了开发者巨大的便利。
 * 并发不是并行：Concurrency Is Not Parallelism
 * 	并发主要由切换时间片来实现“同时”运行，在并行则是直接利用多喝实现多线程的运行，但Go可以设置使用核数，以发挥多喝计算机的能力。
 * Goroutine奉行通过通信来共享内存，而不是共享内存来通信。
 *
 * Channel
 *		Channel 是goroutine沟通的桥梁，大都是阻塞同步的
 *		通过make创建，close关闭
 *		Channel是引用类型
 *		可以使用for range来迭代不断操作channel
 *		可以设置单项或双向通道
 *		可以设置缓存大小，在未被填满前不会发生阻塞
 *
 * Select
 *		可以处理一个或多个channel的发送与接收
 *		同事有多个可用的channel时安随机顺序处理
 *		可用空的select来阻塞main函数
 *		可设置超时
 */

import (
	"fmt"
	"runtime"
	"sync"
	"time"
)

func main() {
	// T1()
	// fmt.Println(".........")
	// T2()
	// fmt.Println(".........")
	// T3()
	// fmt.Println(".........")
	// T4()
	// fmt.Println(".........")
	// T5()
	// fmt.Println(".........")
	T6()
	fmt.Println(".........")
}

//暂停2秒输出信息
func T1() {
	go Go()
	time.Sleep(2 * time.Second) //暂停2秒钟
}

func Go() {
	fmt.Println("Go Go Go !!!")
}

//channel的基本操作
func T2() {
	c := make(chan bool)
	go func() {
		fmt.Println("Go Go Go !!!")
		c <- true //存进去
	}()
	<-c //取出来
}

//迭代channel
func T3() {
	c := make(chan bool)
	go func() {
		fmt.Println("Go Go Go !!!")
		c <- true //存进去
		close(c)  //去掉的话会死锁 会一直在等 直到崩溃退出
	}()
	for v := range c { //迭代channel
		fmt.Println(v)
	}
}

//channel缓存 例子 有缓存是异步的 无缓存是阻塞的
func T4() {
	c := make(chan bool, 1) //缓存大小设置为1
	go func() {
		fmt.Println("Go Go Go !!!")
		<-c //取出来
	}()
	c <- true //存进去
	//先取再存  不会输出， 因为channel有缓存 main在等待结束
}

//多核cpu操作实例
func Go1(c chan bool, index int) {
	a := 1
	for i := 0; i < 100000000; i++ {
		a += i
	}
	fmt.Println(index, a)

	// if index == 9 {
	// 	c <- true
	// }
}

func T5() {
	runtime.GOMAXPROCS(runtime.NumCPU()) //使用多核cpu
	c := make(chan bool, 10)             //基于10核cpu
	for i := 0; i < 10; i++ {
		go Go1(c, i)
	}
	for i := 0; i < 10; i++ {
		<-c
	}
}

func Go2(wg *sync.WaitGroup, index int) {
	a := 1
	for i := 0; i < 100000000; i++ {
		a += i
	}
	fmt.Println(index, a)

	wg.Done()
}

//第二种解决T5的方法
func T6() {
	runtime.GOMAXPROCS(runtime.NumCPU()) //使用多核cpu
	wg := sync.WaitGroup{}
	wg.Add(10)
	for i := 0; i < 10; i++ {
		go Go2(&wg, i) //第一个参数传递的指针的拷贝
	}
	wg.Wait()
}
