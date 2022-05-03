#!/bin/bash
set -e

# install docker
# apt-get update
# apt-get install -y \
#     ca-certificates \
#     curl \
#     gnupg \
#     lsb-release
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
# echo \
#   "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
#   $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# apt-get update
# apt-get install -y docker-ce docker-ce-cli containerd.io

# apt-get install wondershaper

# install and initialize couchdb
# docker pull couchdb
docker stop couchdb || true
docker rm couchdb || true
docker run -itd -p 5984:5984 -e COUCHDB_USER=openwhisk -e COUCHDB_PASSWORD=openwhisk --name couchdb couchdb
sleep 3
docker exec -it couchdb /bin/bash -c \
    "sed '/^\[httpd\].*/a server_options = [{backlog, 128}, {acceptor_pool_size, 16}, {max, 4096}]' -i /opt/couchdb/etc/local.ini"
docker exec -it couchdb /bin/bash -c "curl -X POST http://openwhisk:openwhisk@localhost:5984/_node/_local/_config/_reload"
# pip3 install -r requirements.txt
python3 couchdb_starter.py

# install redis
# docker pull redis
docker stop redis || true
docker rm redis || true
docker run -itd -p 6379:6379 --name redis redis

# run grouping for all benchmarks
cd ../src/grouping
python3 grouping.py video illgal_recognizer fileprocessing wordcount cycles epigenomics genome soykb
