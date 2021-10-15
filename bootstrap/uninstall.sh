#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

BASE_DIR="$HOME/.mac_config"

# configuration steps
rmGithubSource() {
  rm -rf "$BASE_DIR"
}

# https://formulae.brew.sh/formula/
homebrew() {
  # gnu官方的一系列工具
  brew uninstall coreutils
  brew uninstall findutils
  brew uninstall gawk
  brew uninstall gnu-sed

  # 可以生成树形结构
  brew uninstall tree

  # 下载工具
  brew uninstall wget

  # 查找和历史记录
  brew uninstall fzf

  # golang
  brew uninstall go

  # 检测shell语法是否有错
  brew uninstall shellcheck

  # git命令行增强工具
  brew uninstall tig

  # 网络测试工具
  brew uninstall mtr

  # youtube视频下载和视频转码
  brew uninstall ffmpeg
  brew uninstall youtube-dl

  # api查看工具
  brew uninstall homebrew/cask/dash

  # 流程图、UML等
  brew uninstall drawio

  # firefox浏览器
  brew uninstall google-chrome

  # google 浏览器
  brew uninstall firefox

  # google fira-code字体
  brew uninstall font-fira-code

  # 英语纠错工具
  brew uninstall grammarly

  # mac 增强工具
  brew uninstall hammerspoon

  # 开源播放器
  brew uninstall iina

  # 日历小组件
  brew uninstall itsycal

  # markdown编辑器
  brew uninstall typora

  # clickup
  brew uninstall clickup

  # 数据库连接软件
  brew uninstall sequel-ace

  # shell连接工具
  brew uninstall electron

  # gif录制工具
  brew uninstall libcap

  # hosts管理工具
  brew uninstall switchhosts

  # 钉钉
  brew uninstall dingtalk

  # lark
  brew uninstall lark

  # s3管理工具
  brew uninstall cyberduck

  # wechat
  brew uninstall wechat
  brew uninstall qq
  brew uninstall qqmusic

  # 网易云音乐
  brew uninstall neteasemusic

  # 终端工具
  brew uninstall iterm2

  # vpn工具
  brew uninstall tunnelblick

  # vscode
  brew uninstall visual-studio-code

  # sublime
  brew uninstall sublime-text

  # idea
  brew uninstall intellij-idea

  # alfred4
  brew uninstall alfred

  # goland
  brew uninstall goland

  # figma
  brew uninstall figma

  # 禁用mac自带键盘
  brew uninstall karabiner-elements

  # 测网速
  brew uninstall speedtest --force

  # postman
  brew uninstall postman

  # aws cli
  brew uninstall awscli

  # kubectl
  brew uninstall kubectx

  # pod man
  brew uninstall podman

  brew cleanup
}

removeLinks() {
  # for configuration in $HOME
  rm -rf "$HOME/.hammerspoon"
  rm -rf "$HOME/.alias"
  rm -rf "$HOME/.zshrc"
  rm -rf "$HOME/.gitconfig"
  rm -rf "$HOME/.inputrc"
  rm -rf "$HOME/.snape.json"
  rm -rf "$HOME/.terrmaformrc"
}

rmGithubSource
removeLinks
homebrew
