theme_gruvbox dark medium

set -U fish_greeting
#if status is-interactive
#    # Commands to run in interactive sessions can go here
#end

# === PATH ===
export PATH="$PATH:/home/daniel/.local/bin"
export PATH="$PATH:/home/daniel/.cargo/bin"
fish_add_path /home/daniel/.pixi/bin
fish_add_path -gm /home/daniel/go/bin

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# === ENV ===
load_env_file $HOME/.env

export EDITOR="nvim"
export QT_QPA_PLATFORM=xcb

# === CLI TOOL INITIALIZATION ===
set -l _missing_tools

if command -q fzf
    fzf --fish | source
else
    set -a _missing_tools fzf
end

if command -q zoxide
    zoxide init fish | source
else
    set -a _missing_tools zoxide
end

if command -q starship
    starship init fish | source
else
    set -a _missing_tools starship
end

if command -q zellij
    eval (zellij setup --generate-completion fish)
else
    set -a _missing_tools zellij
end

if command -q pixi
    pixi completion --shell fish | source
else
    set -a _missing_tools pixi
end

if command -q direnv
    direnv hook fish | source
else
    set -a _missing_tools direnv
end

if test -x /home/linuxbrew/.linuxbrew/bin/brew
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv fish)"
else
    set -a _missing_tools brew
end

if test (count $_missing_tools) -gt 0
    echo "WARNING: Missing CLI tools: "(string join ", " $_missing_tools)
end

# === ALIAS ===
if command -q eza
    alias ls="eza"
end
alias v='NVIM_APPNAME="kickstart.nvim" nvim'

alias zj='zellij'
alias zja='zellij attach'

# === ZELLIJ SESSIONIZER ===
alias zs='bash $HOME/.local/bin/zellij_sessionizer'
alias ev='z kickstart && zs $PWD'
alias eg='z crisp_gym && zs $PWD'
alias ec='z crisp_py && zs $PWD'

alias g='bash $HOME/.local/bin/open-github.bash'

# === BIND ===
bind \cf "zellij_sessionizer.sh ."

# # >>> mamba initialize >>>
# # !! Contents within this block are managed by 'mamba shell init' !!
# set -gx MAMBA_EXE "/usr/bin/mamba"
# set -gx MAMBA_ROOT_PREFIX "/home/daniel/.local/share/mamba"
# $MAMBA_EXE shell hook --shell fish --root-prefix $MAMBA_ROOT_PREFIX | source
# # <<< mamba initialize <<<
