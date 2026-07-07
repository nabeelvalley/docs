package main

import (
	"fmt"
	"os"

	"example.com/bubbletea-commands/v1"
	"example.com/bubbletea-commands/v2"
)

const help = "Specify either `v1` or `v2` as an argument"

func main() {
	if len(os.Args) < 2 {
		fmt.Println(help)
		return
	}

	arg := os.Args[1]

	switch arg {
	case "v1":
		v1.Run()
	case "v2":
		v2.Run()
	default:
		fmt.Println(help)
	}
}
