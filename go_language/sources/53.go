package main
import (
	"fmt"
)
/**
 * 字符串转数组 然后修改数组的第一个值
 *
 */
func main() {
	s := "hello"
	c := []rune(s)
	c[0] = 's'
	s2 := string(c)
	fmt.Printf("%s", s2);
	fmt.Println("")
}
