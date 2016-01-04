package main

import (
	"bufio"
	"fmt"
	"os"
)

/**
 * 查找重复的行
 *
 *  转换
 *  %d          int變量
 *	%x, %o, %b  分别爲16進製，8進製，2進製形式的int
 *	%f, %g, %e  浮點數： 3.141593 3.141592653589793 3.141593e+00
 *	%t          布爾變量：true 或 false
 *	%c          rune (Unicode碼點)，Go語言里特有的Unicode字符類型
 *	%s          string
 *	%q          帶雙引號的字符串 "abc" 或 帶單引號的 rune 'c'
 *	%v          會將任意變量以易讀的形式打印出來
 *	%T          打印變量的類型
 *	%%          字符型百分比標誌（%符號本身，沒有其他操作）
 * 具体执行方式还不知道
 */
func main() {
	counts := make(map[string]int)
	input := bufio.NewScanner(os.Stdin)
	for input.Scan() {
		counts[input.Text()]++
	}

	for line, n := range counts {
		if n > 1 {
			fmt.Println("%d\t%s\n", n, line)
		}
	}
}
