package main

/**
 * 迭代操作
 *
 */

import (
	"fmt"
)

func main() {
	sm := make([]map[int]string, 5)

	for key, val := range sm { //返回键值对 这里的key如果不用的话是可以直接打给空的   for _, val := range sm{
		val = make(map[int]string, 1)
		val[key] = "ok"
		fmt.Println(val)
	}
	fmt.Println(sm)
	/**
	 * 结果是
	 * map[0:ok]
	 * map[1:ok]
	 * map[2:ok]
	 * map[3:ok]
	 * map[4:ok]
	 * [map[] map[] map[] map[] map[]]
	 * 以上的原因是因为赋值是不会对数据源进行操作的 所以以上的结果是没法使用的
	 */

	/**
	 * 想要使用以上改变的结果的话 就这样用
	 *
	 */
	for i := range sm {
		sm[i] = make(map[int]string, 1)
		sm[i][i] = "ok"
		fmt.Println(sm[i])
	}
	fmt.Println(sm)
	/**
	 * 结果是
	 * map[0:ok]
	 * map[1:ok]
	 * map[2:ok]
	 * map[3:ok]
	 * map[4:ok]
	 * [map[0:ok] map[1:ok] map[2:ok] map[3:ok] map[4:ok]]
	 * 这样数据源就可以在下面的程序中继续使用了
	 */
}
