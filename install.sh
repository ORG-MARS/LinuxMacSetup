#!/bin/bash

BASE_DIR="$HOME/.xiaomo"
echo export BASE_DIR=$BASE_DIR >>~/.bashrc
# shellcheck source=/Users/xiaomo/.bashrc
source ~/.bashrc
echo '######################################################'
echo 设置环境变量:BASE_DIR= ${BASE_DIR}
echo '######################################################'

# 安装git并配置
sudo apt install git -y
echo '######################################################'
echo  '开始安装git.....'
echo '######################################################'

mkdir -p "$BASE_DIR/source"
cd $BASE_DIR/source
git clone https://github.com/houko/macOrLinuxConfigSetup.git "$BASE_DIR/source"
echo '######################################################'
echo clone代码到${BASE_DIR}/source下
echo '######################################################'
git checkout ubuntu20
echo '######################################################'
echo 切换到ubuntu20分支下
echo '######################################################'

echo '######################################################'
echo 开始初始化ubuntu设置
echo '######################################################'
sh $BASE_DIR/source/ubuntu/init_ubuntu.sh

echo '######################################################'
echo 开始设置inputrc
echo '######################################################'
sh $BASE_DIR/source/input/init_inputrc.sh

echo '######################################################'
echo 开始配置环境变量和别名
echo '######################################################'
sh $BASE_DIR/source/env/init_env.sh

echo '######################################################'
echo 开始安装vim环境
echo '######################################################'
sh $BASE_DIR/source/vim/init_vim.sh

echo '######################################################'
echo 开始安装zsh工具
echo '######################################################'
sh $BASE_DIR/source/zsh/init_zsh.sh

echo '######################################################'
echo 开始安装fzf检索工具
echo '######################################################'
sh $BASE_DIR/source/fzf/init_fzf.sh

echo '######################################################'
echo 安装并开启ssh工具
echo '######################################################'
sh $BASE_DIR/source/ssh/init_ssh.sh

echo '######################################################'
echo 开始安装docker
echo '######################################################'
sh $BASE_DIR/source/docker/init_docker.sh

echo '######################################################'
echo 开始安装k8s及周边工具
echo '######################################################'
sh $BASE_DIR/source/k8s/init_k8s.sh
sh $BASE_DIR/source/k8s/init_kubeadm.sh
sh $BASE_DIR/source/k8s/init_kubectx.sh

echo '######################################################'
echo 开始安装terraform
echo '######################################################'
sh $BASE_DIR/source/terraform/init_terraform.sh
