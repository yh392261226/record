package main

import (
    "fmt"
)

/**
 * 內置的len函數返迴一個有符號的int，我們可以像下面例子那樣處理逆序循環。
 * 感觉这就是数组的倒序
 */
func main() {
    medals := []string{"gold", "silver", "bronze"}

    for i := len(medals) - 1; i >= 0; i-- {
        fmt.Println(medals[i]) // "bronze", "silver", "gold"
    }
}
