package main

import (
	"fmt"
	"log"
	"net/http"
	"net"
	"os"
	"os/exec"
)

const dataDirectory = "./garbage/"

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func main() {

	//log.Println("Creating files to serve...")
	//createFilesToServe()

	// create file server handler
	fs := http.FileServer(http.Dir(dataDirectory))

	listener, err := net.Listen("tcp", ":0")
	if err != nil {
    		panic(err)
	}

	fmt.Printf("[%d] --> using port %d \n", os.Getpid() ,listener.Addr().(*net.TCPAddr).Port)

	// start HTTP server with `fs` as the default handler
	log.Fatal(http.Serve(listener, fs))

}

func createFilesToServe() {
	cmd := exec.Command("/bin/sh", "create-files.sh")
	err := cmd.Run()
	check(err)
}
