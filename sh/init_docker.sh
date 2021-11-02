#!/usr/bin/env bash
curl -fsSL get.docker.com -o get-docker.sh
sh get-docker.sh
sudo chmod 666 /var/run/docker.sock

sudo systemctl start docker
sudo systemctl enable docker

# 测试
docker run hello-world