# Setup fzf
# ---------
if [[ ! "$PATH" == */$HOME/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}$HOME/.fzf/bin"
fi

# Auto-completion
# ---------------
# shellcheck source=./fzf/shell/completion.bash
[[ $- == *i* ]] && source "${HOME}/.fzf/shell/completion.bash" 2>/dev/null

# Key bindings
# ------------
source "/Users/xiaomo/.fzf/shell/key-bindings.bash"
