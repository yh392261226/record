package main

import (
	"fmt"
    "errors"
)
/**
 * 错误
 *
 */
func main() {
    err := errors.New("这是错误信息")
    if nil != err {
        fmt.Println(err)
    }
}
