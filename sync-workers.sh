#!/bin/bash
cd ..
rsync --progress --delete -r ./FaaSFlow smc@192.168.1.56:~/

