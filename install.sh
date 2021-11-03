#!/bin/bash

BASE_DIR="$HOME/.xiaomo"

echo export BASE_DIR=$BASE_DIR >> ~/.bashrc
# shellcheck source=/Users/xiaomo/.bashrc
source ~/.bashrc

# 安装git并配置
sudo apt install git -y
mkdir -p "$BASE_DIR/source"
cd $BASE_DIR/source
git clone https://github.com/houko/macOrLinuxConfigSetup.git "$BASE_DIR/source"
git checkout ubuntu20
ln -s "$BASE_DIR/source" "$BASE_DIR/config"

# 初始化ubuntu
sh $BASE_DIR/source/ubuntu/init_ubuntu.sh

# 配置inputrc
sh $BASE_DIR/source/input/init_inputrc.sh

# 配置env
sh $BASE_DIR/source/env/init_env.sh

# 安装vim
sh $BASE_DIR/source/vim/init_vim.sh

# 安装zsh
sh $BASE_DIR/source/zsh/init_zsh.sh

# 安装fzf
sh $BASE_DIR/source/fzf/init_fzf.sh

# 安装并开启ssh
sh $BASE_DIR/source/ssh/init_ssh.sh

# 安装docker
sh $BASE_DIR/source/docker/init_docker.sh

# 安装k8s及周边工具
sh $BASE_DIR/source/k8s/init_k8s.sh
sh $BASE_DIR/source/k8s/init_kubeadm.sh
sh $BASE_DIR/source/k8s/init_kubectx.sh

# 安装terraform
sh $BASE_DIR/source/terraform/init_terraform.sh
