# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -A'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Enable Nice looking bash_prompt if it exists
if [ -f ~/.bash_prompt ]; then
    . ~/.bash_prompt
fi

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
