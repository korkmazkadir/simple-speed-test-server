#!/bin/bash

#Removes folder
rm -rf ./garbage/


#Creates folder
mkdir ./garbage/

#Creates a 1GB file with garbage data
head -c 1000000000 /dev/urandom > ./garbage/test1G