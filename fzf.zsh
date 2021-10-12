# shellcheck shell=bash
# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/xiaomo/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/Users/xiaomo/.fzf/bin"
fi

# Auto-completion
# ---------------
# shellcheck source=./.fzf/shell/completion.zsh
[[ $- == *i* ]] && source "${HOME}/.fzf/shell/completion.zsh" 2>/dev/null

# Key bindings
# ------------
# shellcheck source=./.fzf/shell/key-bindings.zsh
source "$HOME/.fzf/shell/key-bindings.zsh"
