#!/bin/bash

rm -rf ./garbage/

rm -rf .DS_Store

env GOOS=linux GOARCH=amd64 go build -o speed-test-server_linux-amd64

zip -r distribution_amd64_linux.zip ./