#! /bin/bash
#export ES_PATH_CONF=/etc/elasticsearch  # config 경로를 따로 빼는 것을 추천하지만 상황을 감안해 판단할 것
export ES_HOME=/app/elasticsearch/elasticsearch
export PID_DIR=/app/elasticsearch/elasticsearch
cd /app/elasticsearch/elasticsearch
bin/elasticsearch -d -p es.pid

