#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

BASE_DIR="$HOME/.mac_config"

# configuration steps
cloneMacConfigFromGithub() {
  checkDone || return 0
  xcode-select --install 2>/dev/null || true

  mkdir -p "$BASE_DIR/share/github"

  git clone https://github.com/houko/mac_config.git "$BASE_DIR/share/github/mac_config"
  ln -s "$BASE_DIR/share/github/mac_config" "$BASE_DIR/mac_config"
}

# https://formulae.brew.sh/formula/
homebrew() {
  checkDone || return 0
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # 添加cask和cask-fonts源
  brew tap homebrew/cask
  brew tap homebrew/cask-fonts

  # gnu官方的一系列工具
  brew install coreutils
  brew install findutils
  brew install gawk
  brew install gnu-sed

  # 可以生成树形结构
  brew install tree

  # 下载工具
  brew install wget

  # 查找和历史记录
  brew install fzf

  # golang
  brew install go

  # 检测shell语法是否有错
  brew install shellcheck

  # git命令行增强工具
  brew install tig

  # 网络测试工具 需要sudo权限 sudo mtr baidu.com
  brew install mtr

  # youtube视频下载和视频转码
  brew install ffmpeg
  brew install youtube-dl

  # api查看工具
  brew install homebrew/cask/dash

  # 流程图、UML等
  brew install drawio

  # firefox浏览器
  brew install chrome

  # google 浏览器
  brew install firefox

  # google fira-code字体
  brew install font-fira-code

  # 英语纠错工具
  brew install grammarly

  # mac 增强工具
  brew install hammerspoon

  # 开源播放器
  brew install iina

  # 日历小组件
  brew install itsycal

  # markdown编辑器
  brew install typora

  # clickup
  brew install clickup

  # 数据库连接软件
  brew install sequel-ace

  # shell连接工具
  brew install electron

  # gif录制工具
  brew install libcap

  # hosts管理工具
  brew install switchhosts

  # 钉钉
  brew install dingtalk

  # lark
  brew install lark

  # s3管理工具
  brew install cyberduck

  # wechat
  brew install wechat
  brew install qq
  brew install qqmusic

  # 网易云音乐
  brew install neteasemusic

  # 终端工具
  brew install iterm2

  # vpn工具
  brew install tunnelblick

  # vscode
  brew install visual-studio-code

  # sublime
  brew install sublime-text

  # idea
  brew install intellij-idea

  # alfred4
  brew install alfred

  # goland
  brew install goland

  # figma
  brew install figma

  # 禁用mac自带键盘
  brew install karabiner-elements

  # 测网速
  brew tap teamookla/speedtest
  brew update
  brew install speedtest --force

  # postman
  brew install postman

  # 安装oh-my-zsh
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

  # pod man
  brew install podman
  podman machine init
  podman machine start
}

pythonPackages() {
  checkDone || return 0
  python3 -m pip install -U pip
  python3 -m pip install ansible black icdiff poetry psutil ptpython pyflakes pygments requests sh Snape termcolor virtualenv
  touchDone
}

writeDefaults() {
  # disable the dashboard
  defaults write com.apple.dashboard mcx-disabled -bool TRUE
  killall Dock

  # be quiet please finder
  defaults write com.apple.finder FinderSounds -bool FALSE
  killall Finder

  # disable delay when
  defaults write com.apple.dock autohide-fullscreen-delayed -bool FALSE
  killall Dock

  # minimize key repeat
  defaults write -g InitialKeyRepeat -int 10
  defaults write -g KeyRepeat -int 1

}

createLinks() {
  checkDone || return 0
  # for configuration in $HOME
  ln -sf "$BASE_DIR/mac_config/hammerspoon" "$HOME/.hammerspoon"
  ln -sf "$BASE_DIR/mac_config/alias.sh" "$HOME/.alias"
  rm -rf "$HOME/.zshrc"
  ln -sf "$BASE_DIR/mac_config/zshrc" "$HOME/.zshrc"
  ln -sf "$BASE_DIR/mac_config/gitconfig" "$HOME/.gitconfig"
  ln -sf "$BASE_DIR/mac_config/inputrc.sh" "$HOME/.inputrc"
  ln -sf "$BASE_DIR/mac_config/snape.json" "$HOME/.snape.json"
  ln -sf "$BASE_DIR/mac_config/terrmaformrc" "$HOME/.terrmaformrc"

  # for configuration in .config
  mkdir -p "$HOME/.config"
  ln -sf /usr/local/bin/python3 /usr/local/bin/python
  ln -sf /usr/local/bin/pip3 /usr/local/bin/pip
}

cloneMacConfigFromGithub
homebrew
pythonPackages
writeDefaults
createLinks
