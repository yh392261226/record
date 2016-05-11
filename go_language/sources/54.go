package main
import(
	p "fmt"
)
/**
 * 逐个字符打印字符串
 *
 */
func main() {
	str := "whoareyou"
	arr := []rune(str)
	for i := 0; i < len(arr); i++ {
		p.Printf("%s\n", string(arr[i]))
	}
}
