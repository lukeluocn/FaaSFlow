#!/bin/bash
GATEWAY_IP=${GATEWAY_IP:-192.168.1.54}
cd src/workflow_manager
python3 gateway.py ${GATEWAY_IP} 7000
