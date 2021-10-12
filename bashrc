##############
# The basics #
##############
[ -z "$PS1" ] && return
umask 0022

# Global settings.

# Prepend cd to directory names automatically
shopt -s autocd 2> /dev/null

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# explicitly enable term colors.
export TERM="xterm-256color"
export ARCH=`uname -s`

if [ "x$ARCH" = "xLinux" ]
then
    export MAN_POSIXLY_CORRECT=1
    # running on a linux virtual machine.
    COLORS=dircolors
else
    # running on a macOS machine.
    COLORS=gdircolors
fi

xiaomoDIR=~/.xiaomo
etcdir=$xiaomoDIR"/etc"
altdir=$xiaomoDIR"/alt"

# PATH ordering policy: Alt dir things > My own script > Homebrew > System, bin > sbin
export PATH="$altdir/bin:~/.xiaomo/etc/bin:~/.xiaomo/go/bin:/usr/local/opt/ruby/bin:/usr/local/bin:/usr/local/sbin:/bin:/usr/bin:/usr/sbin:/sbin:~/Library/Python/3.7/bin:~/.cargo/bin:/usr/local/opt/coreutils/bin:/usr/local/opt/fzf/bin"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
export LANG=en_US.UTF-8
export DYLD_FALLBACK_LIBRARY_PATH=/usr/local/opt/openssl/lib
export XDG_CONFIG_HOME="$etcdir"

############
# sourcing #
#############

# For things that can be used as alias
. "$etcdir"/alias.sh

# For things that can only be done as a bash function.
if [ -f "$etcdir"/bash_functions ]
then
    . "$etcdir"/bash_functions
fi

# For Alternative settings
if [ -f "$altdir/etc/bashrc" ]
then
    . "$altdir/etc/bashrc"
fi

# for fzf
set rtp+=/usr/local/opt/fzf
[ -f /usr/local/opt/fzf/shell/key-bindings.bash ] && source /usr/local/opt/fzf/shell/key-bindings.bash

# For bash completion.
. "$etcdir"/bash_completion.sh

# configuration for zoxide.
function __zoxide_pwd() {
    \builtin pwd -L
}

# cd + custom logic based on the value of _ZO_ECHO.
function __zoxide_cd() {
    # shellcheck disable=SC2164
    \builtin cd "$@"
}

# Hook to add new entries to the database.
function __zoxide_hook() {
    \builtin local -r __zoxide_retval="$?"
    \builtin local -r __zoxide_pwd_tmp="$(__zoxide_pwd)"
    if [ -z "${__zoxide_pwd_old}" ]; then
        __zoxide_pwd_old="${__zoxide_pwd_tmp}"
    elif [ "${__zoxide_pwd_old}" != "${__zoxide_pwd_tmp}" ]; then
        __zoxide_pwd_old="${__zoxide_pwd_tmp}"
        zoxide add -- "${__zoxide_pwd_old}"
    fi
    return "${__zoxide_retval}"
}

# Jump to a directory using only keywords.
cd() {
    if [ "$#" -eq 0 ]; then
        __zoxide_cd ~
    elif [ "$#" -eq 1 ] && [ "$1" = '-' ]; then
        if [ -n "${OLDPWD}" ]; then
            __zoxide_cd "${OLDPWD}"
        else
            # shellcheck disable=SC2016
            \builtin printf 'zoxide: $OLDPWD is not set\n'
            return 1
        fi
    elif [ "$#" -eq 1 ] && [ -d "$1" ]; then
        __zoxide_cd "$1"
    else
        \builtin local __zoxide_result
        __zoxide_result="$(zoxide query --exclude "$(__zoxide_pwd)" -- "$@")" && __zoxide_cd "${__zoxide_result}"
    fi
}

# I love my prompt
function _xiaomo_prompt {
  status=$?
  __zoxide_hook
  PS1="$(ps1 $status)"
  history -a; history -n;
}

export PROMPT_COMMAND='_xiaomo_prompt'

################
# bash history #
################

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# unlimited playback.
export HISTFILESIZE=99999
export HISTSIZE=99999
export HISTTIMEFORMAT="%h/%d - %H:%M:%S "
# append to the history file, don't overwrite it
shopt -s histappend

#########################
# environment variables #
#########################

export PYTHONSTARTUP=~/.pythonrc
export PYTHONDONTWRITEBYTECODE="False"
export GOPATH="${xiaomoDIR}/go"

# user nvim for everything
export SVN_EDITOR=nvim
export GIT_EDITOR=nvim
export VISUAL=nvim
export EDITOR=nvim

#################
# accessibility #
#################
eval `"$COLORS" "$HOME/.xiaomo/etc/dir_colors"`

# Don’t clear the screen after quitting a manual page.
export MANPAGER='less -X';

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

#####################
# ssh agent forward #
#####################
has_priv_files=$(ls -l ~/.ssh/*.priv >/dev/null 2>&1)
if [ $? -eq 0 ]
then
    SSH_ENV="$HOME/.ssh/environment"

    function start_agent {
        content=`/usr/bin/ssh-agent | sed "/^echo/d"`
        [ -f $SSH_ENV ] && return 0 || echo $content > $SSH_ENV
        chmod 600 "${SSH_ENV}"
        . "${SSH_ENV}" > /dev/null
        /usr/bin/ssh-add ~/.ssh/*.priv
    }

    # Source SSH settings, if applicable
    [ -d $HOME/.xiaomo/var/tmp ] || mkdir -p ~/.xiaomo/var/tmp
    lockfile $HOME/.xiaomo/var/tmp/ssh.lock
    if [ -f "${SSH_ENV}" ]; then
        . "${SSH_ENV}" > /dev/null
        ps ${SSH_AGENT_PID} | grep -q ssh-agent$
        if [ $? -ne 0 ]
        then
            rm -f ${SSH_ENV}
            start_agent
        fi
    else
        start_agent;
    fi
    rm -f $HOME/.xiaomo/var/tmp/ssh.lock
fi
