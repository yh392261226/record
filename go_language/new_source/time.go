package main

import (
	"fmt"
	"time"
)

func main() {
	in1 := "2017/06/23"
	in2 := "2017-07-24"
	in3 := "2017/08/25 17:04:55"
	in4 := "2017-08-26 15:04:55"
	in5 := "16:08:59"

	time1, err1 := time.Parse("2006/01/02", in1) //layout使用"2006-01-02"此数据格式转换会出错
	if err1 != nil {
		fmt.Println("您输入的不是日期时间格式的数据")
		return
	}
	fmt.Println("日期时间1: ", time1)

	time2, err2 := time.Parse("2006-01-02", in2) //layout使用"2006/01/02"此数据格式转换会出错
	if err2 != nil {
		fmt.Println("您输入的不是日期时间格式的数据")
		return
	}
	fmt.Println("日期时间2: ", time2)

	time3, err3 := time.Parse("2006/01/02 15:04:05", in3) //layout使用"2006-01-02 15:04:05"此数据格式转换会出错
	if err3 != nil {
		fmt.Println("您输入的不是日期时间格式的数据")
		return
	}
	fmt.Println("日期时间3: ", time3)

	time4, err4 := time.Parse("2006-01-02 15:04:05", in4) //layout使用"2006/01/02 15:04:05"此数据格式转换会出错
	if err4 != nil {
		fmt.Println("您输入的不是日期时间格式的数据")
		return
	}
	fmt.Println("日期时间4: ", time4)
	fmt.Println("日期时间4: ", time4.Truncate(time.Second).Format("15:04:05"))

	time5, err5 := time.Parse("15:04:05", in5) //layout使用"15:04:05"
	if err5 != nil {
		fmt.Println("您输入的不是时间格式的数据")
		return
	}
	fmt.Println("时间5: ", time5)
	fmt.Println("时间5: ", time5.Format("15:04:05"))

	unix1 := time1.Unix()
	unix2 := time2.Unix()
	fmt.Println("Unix: ", unix1)
	fmt.Println("Unix: ", unix2)
	fmt.Println(time.Unix(unix1, 0).Format("2006-01-02 09:00:00"))
	fmt.Println(time.Unix(unix2, 0).Format("2006-01-02 00:00:00"))
	fmt.Println(time.Unix(unix2, 0).Format("2006-01-02"))

	//in6 := "16h08m59s" // 在一个年月日时分秒格式的日期上加上16小时8分59秒
	in6 := "-02h08m39s" // 在一个年月日时分秒格式的日期上减去2小时8分39秒
	du, err6 := time.ParseDuration(in6)
	if err6 != nil {
		fmt.Println("您输入的不是时间格式的数据")
		return
	}

	time6, _ := time.Parse("2006-01-02 15:04:05", "2017-08-26 15:04:55")
	//newTime6 := time6.Add(du) // 在一个年月日时分秒格式的日期上加上16小时8分59秒
	newTime6 := time6.Add(du) // 在一个年月日时分秒格式的日期上减去2小时8分39秒
	fmt.Println("日期时间和：", newTime6)
}
