#!/bin/bash

BASE_DIR="$HOME/.mac_config"

cloneMacConfigFromGithub() {
  xcode-select --install 2>/dev/null || true

  mkdir -p "$BASE_DIR/share/github"

  git clone https://github.com/houko/mac_config.git "$BASE_DIR/share/github/mac_config"
  ln -s "$BASE_DIR/share/github/mac_config" "$BASE_DIR/mac_config"
}

# https://formulae.brew.sh/formula/
homebrew() {
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # 添加cask和cask-fonts源
  brew tap homebrew/cask
  brew tap homebrew/cask-fonts
  brew tap homebrew/cask-versions

  brew update
  brew upgrade

  # gnu官方的一系列工具
  brew install coreutils
  brew install findutils
  brew install gawk
  brew install gnu-sed

  # 可以生成树形结构
  brew install tree
  tree --version

  # 下载工具
  brew install wget
  wget --version

  # 查找和历史记录
  brew install fzf

  # golang
  brew install go
  go version

  # 检测shell语法是否有错
  brew install shellcheck

  # git命令行增强工具
  brew install gh
  brew install tig
  tiv -v

  # 网络测试工具 需要sudo权限 sudo mtr baidu.com
  brew install mtr
  mtr -v

  # youtube视频下载和视频转码
  brew install ffmpeg
  brew install youtube-dl

  # api查看工具
  brew install homebrew/cask/dash

  # 流程图、UML等
  brew install drawio

  # firefox浏览器
  brew install google-chrome

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
  brew install electerm

  # gif录制工具
  brew install licecap

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
  brew tap benwebber/tunnelblickctl
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

  brew install tmux

  # 禁用mac自带键盘
  brew install karabiner-elements

  # 测网速
  brew tap teamookla/speedtest
  brew update
  brew install speedtest --force
  speedtest -v

  # aws cli
  brew install awscli@2
  aws -v

  # 可以切换k8s集群
  brew install kubectx
  kubectx -v

  # google chrome
  brew install google-drive

  # postman
  brew install --cask postman

  # nodejs版本管理
  brew install n
  sudo n 14
  node -v
  npm -v
  npm install -g yarn
  yarn -v

  # terraform 管理
  brew install tfenv
  tfenv install 1.0.9
  tfenv use 1.0.9
  terraform -v

  # istioctl
  brew install istioctl
  istioctl version

  # jdk 11
  brew install corretto11
  java --version

  # golang版本控制
  bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
  gvm install 1.17
  gvm use 1.17
  go version

  # 安装oh-my-zsh
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
  # p10k configure 可以重新配置
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/themes/powerlevel10k
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting

  # pod man
  brew install podman
  podman machine init
  podman machine start
  podman -v

  brew cleanup
}

pythonPackages() {
  sudo python3 -m pip install -U pip
  pip --version
  sudo python3 -m pip install psutil pyflakes pygments requests sh Snape termcolor virtualenv

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
  # for configuration in $HOME
  ln -sf "$BASE_DIR/mac_config/hammerspoon" "$HOME/.hammerspoon"
  echo "$BASE_DIR/mac_config/hammerspoon" link to "$HOME/.hammerspoon"

  ln -sf "$BASE_DIR/mac_config/alias.sh" "$HOME/.alias"
  echo "$BASE_DIR/mac_config/alias.sh" link to "$HOME/.alias"

  rm -rf "$HOME/.zshrc"
  ln -sf "$BASE_DIR/mac_config/zshrc" "$HOME/.zshrc"
  echo "$BASE_DIR/mac_config/zshrc" link to "$HOME/.zshrc"

  ln -sf "$BASE_DIR/mac_config/gitconfig" "$HOME/.gitconfig"
  echo "$BASE_DIR/mac_config/gitconfig" link to "$HOME/.gitconfig"

  ln -sf "$BASE_DIR/mac_config/inputrc.sh" "$HOME/.inputrc"
  echo "$BASE_DIR/mac_config/inputrc.sh" link to "$HOME/.inputrc"

  ln -sf "$BASE_DIR/mac_config/snape.json" "$HOME/.snape.json"
  echo "$BASE_DIR/mac_config/snape.json" link to "$HOME/.snape.json"

  ln -sf "$BASE_DIR/mac_config/terrmaformrc" "$HOME/.terrmaformrc"
  echo "$BASE_DIR/mac_config/terrmaformrc" link to "$HOME/.terrmaformrc"

  # for configuration in .config
  mkdir -p "$HOME/.config"
  ln -sf /usr/local/bin/python3 /usr/local/bin/python
  echo /usr/local/bin/python3 link to /usr/local/bin/python

  ln -sf /usr/local/bin/pip3 /usr/local/bin/pip
  echo /usr/local/bin/pip3 link to /usr/local/bin/pip
}

cloneMacConfigFromGithub
homebrew
pythonPackages
writeDefaults
createLinks
