package main
import (
	"fmt"
	"os"
)

func main() {
	name := "55.go"
	f, err := os.Open(name, os.O_RDONLY, 0)
	if err != nil {
		return err
	}
	d, err := f.Stat()
	if err != nil {
		return err
	}
	fmt.Println("test")
}
