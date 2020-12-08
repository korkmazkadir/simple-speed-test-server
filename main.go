package main

import (
	"log"
	"net/http"
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

	log.Println("listening on port 9000...")
	// start HTTP server with `fs` as the default handler
	log.Fatal(http.ListenAndServe(":9000", fs))

}

func createFilesToServe() {
	cmd := exec.Command("/bin/sh", "create-files.sh")
	err := cmd.Run()
	check(err)
}
