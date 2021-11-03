#!/bin/bash

BASE_DIR="$HOME/.xiaomo"
# 安装git并配置
sh ./git/init_git.sh
mkdir -p "$BASE_DIR/source"
git clone https://github.com/houko/macOrLinuxConfigSetup.git "$BASE_DIR/source"
git checkout ubuntu20
ln -s "$BASE_DIR/source" "$BASE_DIR/config"

# 初始化ubuntu
sh ./ubuntu/init_ubuntu.sh

# 配置inputrc
sh ./input/init_inputrc.sh

# 配置env
sh ./env/init_env.sh

# 安装vim
sh ./vim/init_vim.sh

# 安装zsh
sh ./zsh/init_zsh.sh

# 安装fzf
sh ./fzf/init_fzf.sh

# 安装并开启ssh
sh ./ssh/init_ssh.sh

# 安装docker
sh ./docker/init_docker.sh

# 安装k8s及周边工具
sh ./k8s/init_k8s.sh
sh ./k8s/init_kubeadm.sh
sh ./k8s/init_kubectx.sh

# 安装terraform
sh ./terraform/init_terraform.sh
