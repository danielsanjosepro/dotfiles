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

alias zj='zellij'
alias zja='zellij attach'

# === ZELLIJ SESSIONIZER ===
alias zs='bash $HOME/.local/bin/zellij_sessionizer'
alias ev='z kickstart && zs $PWD'
alias eg='z crisp_gym && zs $PWD'
alias ec='z crisp_py && zs $PWD'

eval (zellij setup --generate-completion fish)

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

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba shell init' !!
set -gx MAMBA_EXE "/usr/bin/mamba"
set -gx MAMBA_ROOT_PREFIX "/home/daniel/.local/share/mamba"
$MAMBA_EXE shell hook --shell fish --root-prefix $MAMBA_ROOT_PREFIX | source
# <<< mamba initialize <<<
