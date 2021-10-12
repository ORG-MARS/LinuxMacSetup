#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

BASE_DIR="$HOME/.xiaomo"

# helpers
checkDone() {
  done_dir="$BASE_DIR/var/run/done"
  mkdir -p "$done_dir"
  func="${FUNCNAME[1]}"
  if [ -f "$done_dir/$func" ]; then
    return 1
  else
    return 0
  fi
}

touchDone() {
  done_dir="$BASE_DIR/var/run/done"
  func="${FUNCNAME[1]}"
  touch "$done_dir/$func"
}

# configuration steps
cloneEtc() {
  checkDone || return 0
  xcode-select --install 2>/dev/null || true

  mkdir -p "$BASE_DIR/share/github"

  while true; do
    has_git=$(git --version 2>/dev/null || echo "false")
    if [ "$has_git" != "false" ]; then
      break
    fi
    echo "sleeping"
    sleep 5
  done

  git clone https://github.com/houko/mac_config.git "$BASE_DIR/share/github/mac_config"
  ln -s "$BASE_DIR/share/github/mac_config" "$BASE_DIR/mac_config"
  touchDone()
}

homebrew() {
  checkDone || return 0
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  brew install bash
  brew install bash-completion
  brew install coreutils
  brew install findutils
  brew install gawk
  brew install gcc
  brew install git-delta
  brew install gnu-sed
  brew install gnu-tar
  brew install gnu-time
  brew install gnutls
  brew install openssl
  brew install procmail
  brew install readline
  brew install tree
  brew install wget
  brew install colordiff
  brew install cwlogs
  brew install ffmpeg
  brew install fzf
  brew install git
  brew install go
  brew install jq
  brew install python3
  brew install shellcheck
  brew install sqlite
  brew install tig
  brew install mtr
  brew install mpv
  brew install p7zip
  brew install youtube-dl
  brew install zoxide

  brew tap homebrew/cask
  brew tap homebrew/cask-fonts

  brew install basictex
  brew install bitwarden
  brew install homebrew/cask/dash
  brew install drawio
  brew install chrome
  brew install firefox
  brew install font-fira-code
  brew install grammarly
  brew install hammerspoon
  brew install iina
  brew install itsycal
  brew install slack
  brew install typora
  brew install zoom
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

  # Disable smarts, I don't need your help thanks.
  defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
  defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
  defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

  touchDone
}

buildPs1() {
  checkDone || return 0
  brew install libgit2
  cd "$BASE_DIR/mac_config/go"
  go build -o ../bin/ps1 ps1.go
  touchDone
}

createLinks() {
  checkDone || return 0
  # for configuration in $HOME
  ln -sf "$BASE_DIR/mac_config/bashrc" "$HOME/.bashrc"
  ln -sf "$HOME/.bashrc" "$HOME/.bash_profile"
  ln -sf "$BASE_DIR/mac_config/gitconfig" "$HOME/.gitconfig"
  ln -sf "$BASE_DIR/mac_config/hammerspoon" "$HOME/.hammerspoon"
  ln -sf "$BASE_DIR/mac_config/inputrc.sh" "$HOME/.inputrc"
  ln -sf "$BASE_DIR/mac_config/pythonrc.py" "$HOME/.pythonrc"
  ln -sf "$BASE_DIR/mac_config/ptpython" "$HOME/.ptpython"
  ln -sf "$BASE_DIR/mac_config/snape.json" "$HOME/.snape.json"
  ln -sf "$BASE_DIR/mac_config/nvim" "$HOME/.vim"
  ln -sf "$BASE_DIR/share/github" "$HOME/.Github"
  ln -sf "$BASE_DIR/share/ssh" "$HOME/.ssh"

  # for configuration in .config
  mkdir -p "$HOME/.config"
  ln -sf /usr/local/bin/python3 /usr/local/bin/python
  ln -sf /usr/local/bin/pip3 /usr/local/bin/pip
  touchDone
}

miscConfig() {
  checkDone || return 0
  chsh -s /bin/bash
  nvim +PackerSync +qall
  (cd "$BASE_DIR/mac_config" && git remote set-url origin git@github.com:xiaomo/mac_config.git)
  touchDone
}

cloneEtc
homebrew
pythonPackages
writeDefaults
buildPs1
createLinks
miscConfig
