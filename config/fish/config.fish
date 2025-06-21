theme_gruvbox dark medium

set -U fish_greeting
#if status is-interactive
#    # Commands to run in interactive sessions can go here
#end


# Set up fzf key bindings
fzf --fish | source

zoxide init fish | source

# === ALIAS ===
alias ls="eza"
alias v='NVIM_APPNAME="kickstart.nvim" nvim'
alias ev='z kickstart && v .'

# === PATH ===
export PATH="$PATH:/home/daniel/.local/bin"
export PATH="$PATH:/home/daniel/.cargo/bin"

pixi completion --shell fish | source

# === ENV ===
load_env_file $HOME/.env

export EDITOR="nvim"

# === BIND ===
bind \cf "zellij_sessionizer.sh ."
fish_add_path /home/daniel/.pixi/bin
