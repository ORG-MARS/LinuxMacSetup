export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

export TF_SWITCH_HOME=/Users/xiaomo/.terraform.versions
export PATH=$TF_SWITCH_HOME:$PATH

# shellcheck disable=SC1090
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Kubernetes 自动补全
complete -o nospace -C /opt/homebrew/bin/terraform terraform
# shellcheck disable=SC1090
source <(kubectl completion zsh)
# shellcheck disable=SC2078
# shellcheck disable=SC1090
[[ /usr/local/bin/kubectl ]] && source <(kubectl completion zsh)
complete -F __start_kubectl k