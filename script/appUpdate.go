package main

import (
	"flag"
	"fmt"
	"github.com/tidwall/gjson"
	"io/ioutil"
	"net/http"
	"strconv"
	"strings"
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

	value := gjson.Get(string(body), "message.vesionNum")
	//fmt.Println("value=",value.String())
	return value.String()
}

func httpPost(typestr string, idres string, versionNum string, downloadurl string) {
	var url = "http://riversm.huntingspeed.com/appvesion"
	client := &http.Client{}

	req, err := http.NewRequest("POST", url, strings.NewReader("type="+typestr+"&idResponsibleType="+idres+"&vesionNum="+versionNum+"&url="+downloadurl))
	if err != nil {
		// handle error
		panic(err)
	}

	req.Header.Set("Content-Type", "application/x-www-form-urlencoded")
	req.Header.Set("Authorization", "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vcml2ZXJzbS5odW50aW5nc3BlZWQuY29tL2xvZ2luIiwiaWF0IjoxNTE2Njg2NzQ4LCJleHAiOjE1NTI2ODY3NDgsIm5iZiI6MTUxNjY4Njc0OCwianRpIjoiZGNmYjBhODdlNzU2ZDc5NTVjY2UzMDc2OTBiNWEwMmUiLCJzdWIiOjE5fQ.TECbpiUsIKuigNKRzDLxHgyX7fRbuevz_OGGQt_9yLo")

	resp, err := client.Do(req)
	defer resp.Body.Close()

	body, err := ioutil.ReadAll(resp.Body)

	if err != nil {
		// handle error
		panic(err)
	}

	fmt.Println("POST返回数据:", string(body))
}

func main() {

	typePtr := flag.Int("type", 1, "type=1代表安卓手机(默认为1)")
	downloadurlPtr := flag.String("url", "", "url为下载地址：http://app.smhzz.cn/app-sanming_5_1.0.5.apk")
	versionNumPtr := flag.Int("versionNum", 0, "versionNum为系统更新版本迭代")

	flag.Parse()
	// var versionNum = 2;
	// var downloadurl = "http://app.smhzz.cn/app-sanming_1.0.4.apk";

	var typestr = strconv.Itoa(*typePtr)
	var downloadurl = *downloadurlPtr
	var versionNum = strconv.Itoa(*versionNumPtr)
	//fmt.Println("url:",downloadurl);
	// resp,err := http.Get(downloadurl)
	// if err != nil {
	//     panic(err)
	// }
	// defer resp.Body.Close()
	// body, err := ioutil.ReadAll(resp.Body)
	// if err != nil {
	//     // handle error
	//      panic(err);
	// }
	// fmt.Println("测试URL:",string(body))

	fmt.Println("type:", typestr)
	fmt.Println("url:", downloadurl)
	fmt.Println("versionNum:", versionNum)

	//httpGet(typestr,"1");
	//fmt.Println("ret:",ret);

	httpPost(typestr, "1", versionNum, downloadurl)
	httpGet(typestr, "1")
	httpPost(typestr, "2", versionNum, downloadurl)
	httpGet(typestr, "2")
}
