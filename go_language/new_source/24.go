package main

/**
 * 对map的间接排序
 *
 */

import (
	"fmt"
	"sort"
)

func main() {
	m := map[int]string{1: "a", 2: "b", 3: "c", 4: "d", 5: "e"}
	s := make([]int, len(m))

	i := 0
	for key := range m { //这可以这样写for key,_ := range m{
		s[i] = key
		i++
	}
	sort.Ints(s)
	fmt.Println(s)

	/**
	 * 键值对调
	 *
	 */
	m1 := map[int]string{1: "a", 2: "b", 3: "c", 4: "d", 5: "e"}
	fmt.Println(m1)
	m2 := make(map[string]int)
	for key, val := range m1 {
		m2[val] = key
	}
	fmt.Println(m2)
}
