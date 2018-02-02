package main

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"strconv"
	"time"

	"github.com/andlabs/ui"
)

func httpGet(typestr string, idres string) string {
	var url = "http://riversm.huntingspeed.com/appvesion?type=" + typestr + "&idresponsibletype=" + idres
	//fmt.Println(url);
	resp, err := http.Get(url)
	if err != nil {
		// handle error
		panic(err)
	}

	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		// handle error
		panic(err)
	}
	fmt.Println(string(body))

	//value := gjson.Get(string(body), "message.vesionNum")
	//fmt.Println("value=",value.String())
	//value.String()
	return string(body)
}

func counter(label *ui.Label) {
	for i := 0; i < 5; i++ {
		time.Sleep(time.Second)
		ui.QueueMain(func() {
			label.SetText("number " + strconv.Itoa(i))
		})

		//ui.NewSpinbox(min, max)
	}
}

func main() {
	err := ui.Main(func() {
		input := ui.NewEntry()
		button := ui.NewButton("Greet")
		greeting := ui.NewLabel("123")
		box := ui.NewVerticalBox()
		box.Append(ui.NewLabel("Enter your name:"), false)
		box.Append(input, false)
		box.Append(button, false)
		box.Append(greeting, false)
		window := ui.NewWindow("Hello", 200, 100, false)
		window.SetMargined(true)
		window.SetChild(box)
		button.OnClicked(func(*ui.Button) {
			var txt = httpGet("1", input.Text())
			greeting.SetText("Hello, " + input.Text() + "!" + txt)
		})

		label := ui.NewLabel("text")
		box.Append(label, false)
		//window.SetChild(label)

		window.OnClosing(func(*ui.Window) bool {
			ui.Quit()
			return true
		})
		window.Show()

		go counter(label)
	})
	if err != nil {
		panic(err)
	}
}
