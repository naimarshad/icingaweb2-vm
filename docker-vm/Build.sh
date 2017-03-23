#!/bin/bash

#Simple script to install & run docker 
echo "Installing docker repositories to install docker"
echo "################################################################################"
yum -y update; yum clean all;
yum -y install yum-utils vim
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum -y install docker-ce
yum -y clean all

echo "Enabling the docker at boot & starting the daemon"
echo "################################################################################"
systemctl enable docker && systemctl start docker

echo "Downloading & installing docker compose"
echo "################################################################################"
curl -L "https://github.com/docker/compose/releases/download/1.11.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose


echo "Changing into docker-compose directory to build & run the required containers"
echo "################################################################################"
cd compose
docker-compose up -d
