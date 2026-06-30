#!/bin/bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

CONFIG_LIST=(
	dunst
	hypr
	nvim
	darktable
	waybar
	vis
	wezterm
	zellij
	i3
	i3status-rust
	rofi
	wofi
	fish
	tmux
)

CONFIG_DIR="$HOME/.config"
LOCAL_BIN_DIR="$HOME/.local/bin"

mkdir -p "$CONFIG_DIR" "$LOCAL_BIN_DIR"

link_path() {
	local source="$1"
	local target="$2"

	rm -rf "$target"
	ln -s "$source" "$target"
}

echo "Linking configs..."
for NAME in "${CONFIG_LIST[@]}"; do
	echo "  $NAME"
	link_path "$DOTFILES_DIR/config/$NAME" "$CONFIG_DIR/$NAME"
done

echo "Linking dotfiles..."
link_path "$DOTFILES_DIR/zsh/.zshrc"               "$HOME/.zshrc"               && echo "  .zshrc"
link_path "$DOTFILES_DIR/zsh/.p10k.zsh"            "$HOME/.p10k.zsh"            && echo "  .p10k.zsh"
link_path "$DOTFILES_DIR/zsh/.p10k_simple.zsh"     "$HOME/.p10k_simple.zsh"     && echo "  .p10k_simple.zsh"
link_path "$DOTFILES_DIR/zsh/.p10k_complex.zsh"    "$HOME/.p10k_complex.zsh"    && echo "  .p10k_complex.zsh"
link_path "$DOTFILES_DIR/zsh/.zshrc.pre-oh-my-zsh" "$HOME/.zshrc.pre-oh-my-zsh" && echo "  .zshrc.pre-oh-my-zsh"
link_path "$DOTFILES_DIR/.gitconfig"               "$HOME/.gitconfig"           && echo "  .gitconfig"
link_path "$DOTFILES_DIR/.bash_prompt"             "$HOME/.bash_prompt"         && echo "  .bash_prompt"

mkdir -p "$HOME/.claude"
link_path "$DOTFILES_DIR/claude/settings.json"     "$HOME/.claude/settings.json" && echo "  .claude/settings.json"

echo "Linking bin..."
link_path "$DOTFILES_DIR/bin/zellij_sessionizer"    "$LOCAL_BIN_DIR/zellij_sessionizer"   && echo "  zellij_sessionizer"
link_path "$DOTFILES_DIR/bin/tmux_sessionizer"      "$LOCAL_BIN_DIR/tmux_sessionizer"     && echo "  tmux_sessionizer"
link_path "$DOTFILES_DIR/bin/claude-tmux-notify"    "$LOCAL_BIN_DIR/claude-tmux-notify"   && echo "  claude-tmux-notify"
link_path "$DOTFILES_DIR/bin/tmux-claude-statusline" "$LOCAL_BIN_DIR/tmux-claude-statusline" && echo "  tmux-claude-statusline"
link_path "$DOTFILES_DIR/scripts/open-github.bash"  "$LOCAL_BIN_DIR/open-github.bash"     && echo "  open-github.bash"

echo "Done."

ask() {
	local prompt="$1"
	local default="${2:-n}"
	local hint
	[[ "$default" == "y" ]] && hint="[Y/n]" || hint="[y/N]"
	read -r -p "$prompt $hint " answer
	local reply="${answer:-$default}"
	[[ "${reply,,}" == "y" ]]
}

if ask "Run Pi install?" y; then
	bash "$DOTFILES_DIR/scripts/install-pi.sh"
fi

if ask "Run full desktop install?" n; then
	bash "$DOTFILES_DIR/scripts/desktop-post-install.sh"
fi
