#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

BASE_DIR="$HOME/.xiaomo"

# helpers
checkDone() {
  done_dir="$BASE_DIR/var/run/done"
  mkdir -p "$done_dir"
  func="${FUNC_NAME[1]}"
  if [ -f "$done_dir/$func" ]; then
    return 1
  else
    return 0
  fi
}

touchDone() {
  done_dir="$BASE_DIR/var/run/done"
  func="${FUNC_NAME[1]}"
  touch "$done_dir/$func"
}

# configuration steps
cloneMacConfigFromGithub() {
  checkDone || return 0
  xcode-select --install 2>/dev/null || true

  mkdir -p "$BASE_DIR/share/github"

  git clone https://github.com/houko/mac_config.git "$BASE_DIR/share/github/mac_config"
  ln -s "$BASE_DIR/share/github/mac_config" "$BASE_DIR/mac_config"
  touchDone
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

  # pod man
  brew install podman
  podman machine init
  podman machine start
  touchDone
}

pythonPackages() {
  checkDone || return 0
  python3 -m pip install -U pip
  python3 -m pip install ansible black icdiff poetry psutil ptpython pyflakes pygments requests sh Snape termcolor virtualenv
  touchDone
}

writeDefaults() {
  checkDone || return 0

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

  touchDone
}

createLinks() {
  checkDone || return 0
  # for configuration in $HOME
  ln -sf "$BASE_DIR/mac_config/zshrc" "$HOME/.zshrc"
  ln -sf "$BASE_DIR/mac_config/gitconfig" "$HOME/.gitconfig"
  ln -sf "$BASE_DIR/mac_config/hammerspoon" "$HOME/.hammerspoon"
  ln -sf "$BASE_DIR/mac_config/inputrc.sh" "$HOME/.inputrc"
  ln -sf "$BASE_DIR/mac_config/ptpython" "$HOME/.ptpython"
  ln -sf "$BASE_DIR/mac_config/snape.json" "$HOME/.snape.json"

  # for configuration in .config
  mkdir -p "$HOME/.config"
  ln -sf /usr/local/bin/python3 /usr/local/bin/python
  ln -sf /usr/local/bin/pip3 /usr/local/bin/pip
  touchDone
}

cloneMacConfigFromGithub
homebrew
pythonPackages
writeDefaults
createLinks
