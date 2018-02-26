package main

import (
	"fmt"
	_ "golang.org/x/tour/wc"
	"strings"
)

func defer_f() (result int) {
	defer func() {
		result++
	}()
	return 0
}

func defer_f2() (r int) {
	t := 5
	defer func() {
		t = t + 5
	}()
	return t
}

func defer_f3() (r int) {
	defer func(r int) {
		r = r + 5
	}(r)
	return 1
}

func WordCount(s string) map[string]int {
	s_array := strings.Fields(s)
	m := make(map[string]int)
	for i := 0; i < len(s_array); i++ {
		_, ok := m[s_array[i]]
		if ok == false {
			m[s_array[i]] = 1
		} else {
			m[s_array[i]]++
		}
	}
	return m
}

func main() {
	//wc.Test(WordCount)
	ret := defer_f()
	ret2 := defer_f2()
	ret3 := defer_f3()
	fmt.Println(ret, ret2, ret3)

	fmt.Println(string([]rune("字zi符fu串chuan")[:5]))

	fmt.Println(len(string([]rune("编"))))
}
