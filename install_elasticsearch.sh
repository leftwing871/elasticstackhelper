#! /bin/bash

#AWS EC2 Instance User 생성
#elastic Group 추가
groupadd elastic

#elastic User 추가
useradd elastic -g elastic -m -s /bin/bash

#sudo su -
echo 'elastic!' | passwd --stdin elastic

#/etc/sudoers 는 Read Only 이기 때문에 권한을 변경해준다.
chmod 640 /etc/sudoers

#Sudoer 권한 추가
echo "elastic    ALL=(ALL)       ALL" >> /etc/sudoers

#어플리케이션용 Directory
mkdir -p /app/elasticsearch

#데이터용 Directory
mkdir -p /data/elasticsearch

#로그용 Directory
mkdir -p /log/elasticsearch


cd /app/elasticsearch
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.7.0-linux-x86_64.tar.gz
tar -xvzf elasticsearch-7.7.0-linux-x86_64.tar.gz

echo "elastic soft nofile 262144" >> /etc/security/limits.conf
echo "elastic hard nofile 262144" >> /etc/security/limits.conf
echo "elastic soft memlock unlimited" >> /etc/security/limits.conf
echo "elastic hard memlock unlimited" >> /etc/security/limits.conf

echo "vm.max_map_count = 262144" >> /etc/sysctl.conf

sed -i -e "s/-Xms1g/-Xms2g/g" /app/elasticsearch/elasticsearch-7.7.0/config/jvm.options
sed -i -e "s/-Xmx1g/-Xmx2g/g" /app/elasticsearch/elasticsearch-7.7.0/config/jvm.options

sed -i -e "s/#network.host: 192.168.0.1/network.host: ["_site_", "_local_"]/g" /app/elasticsearch/elasticsearch-7.7.0/config/elasticsearch.yml
sed -i -e "s/#node.name: node-1/node.name: ${HOSTNAME}/g" /app/elasticsearch/elasticsearch-7.7.0/config/elasticsearch.yml
sed -i -e "s/#path.data: \/path\/to\/data/path.data: \/data\/elasticsearch/g" /app/elasticsearch/elasticsearch-7.7.0/config/elasticsearch.yml
sed -i -e "s/#path.logs: \/path\/to\/logs/path.logs: \/log\/elasticsearch/g" /app/elasticsearch/elasticsearch-7.7.0/config/elasticsearch.yml
sed -i -e "s/#discovery.seed_hosts: \[\"host1\", \"host2\"\]/discovery.seed_hosts: \[\"127.0.0.1\"\]/g" /app/elasticsearch/elasticsearch-7.7.0/config/elasticsearch.yml

ln -s /app/elasticsearch/elasticsearch-7.7.0/ /app/elasticsearch/elasticsearch

chown -R elastic:elastic /app/elasticsearch
chown -R elastic:elastic /data/elasticsearch
chown -R elastic:elastic /log/elasticsearch

