alias grep='grep --color'

# Generic
alias su='su -'
alias df='df -h'

alias ll='ls -l'
alias lsa='ls -al'
alias lla='ls -al'

alias py3='python3'
alias which='type -p'
alias md='mkdir -pv'

alias daemon='supervisorctl -c ~/.supervisord.conf'
alias act='source venv/bin/activate'
# 强制遗忘docker神技
#alias docker='podman'

# 随机一个可用端口
alias randp='python -c "import random; print(random.randint(1025, 32768))"'
# 更新并清理brew管理的软件
alias brewup='brew update && brew upgrade && brew cleanup'
# 生成一个新的ssh key
alias gssh='ssh-keygen'
# 查看外网Ip
alias ip='dig +short myip.opendns.com @resolver1.opendns.com'
# 查看本机ip
alias localhost='ifconfig eth0 | grep inet'

#当前时间
alias now="date +'%Y-%m-%d %T'"

# clear
alias clera='clear'
alias clar='clear'
alias cls='clear'

# make相关操作
alias mn='make clean'
alias mt='make test'
alias mkae='make'
alias maek='make'

# 目录跳转
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# git
alias ga='git add'
alias gti='git'

alias key="ssh-keygen"

# kubectl setting
alias k=kubectl
alias kx=kubectx
alias kg='kubectl get'
alias kgp='kubectl get pods'
alias kgpjson='kubectl get pods -o=json'
alias kgpn='kubectl get pods -n'

# tmux
alias tl='tmux list-sessions'
alias tkss='tmux kill-session -t'
alias ta='tmux attach -t'
alias ts='tmux new-session -s'
