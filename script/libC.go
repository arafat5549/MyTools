package main

import "C"

func main() {}

//export Foo
func Foo(i int) int { return i + 42 }
