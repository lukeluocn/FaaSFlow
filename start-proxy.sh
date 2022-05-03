#!/bin/bash
WORKER_IP=${WORKER_IP:-192.168.1.56}
cd src/workflow_manager
python3 proxy.py ${WORKER_IP} 8000
