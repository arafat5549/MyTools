package main

import (
	_ "flag"
	"fmt"
	"os"
	"strconv"
)

func main() {

	//cnstr := flag.String("", "", "设置输出编码")
	//flag.Parse()
	//fmt.Println("type:", *cnstr)
	//fmt.Println(os.Args)
	fmt.Println(os.Args[1])
	cnstr := os.Args[1]
	rs := []rune(cnstr) //"golang中文unicode编码"
	json := ""
	html := ""
	ps := ""
	for _, r := range rs {
		rint := int(r)
		if rint < 128 {
			json += string(r)
			html += string(r)
			ps += string(r)
		} else {
			json += "\\u" + strconv.FormatInt(int64(rint), 16) // json
			html += "&#" + strconv.Itoa(int(r)) + ";"          // 网页
			ps += "0x" + strconv.FormatInt(int64(rint), 16)    // 0x
		}
	}
	fmt.Printf("JSON: %s\n", json)
	fmt.Printf("HTML: %s\n", html)
	fmt.Printf("PowerShell: %s\n", ps)
}
