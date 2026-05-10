#!/bin/bash

set -euo pipefail

# Get the directory of the script
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# List of folders to symlink
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
)

CONFIG_DIR="$HOME/.config"
LOCAL_BIN_DIR="$HOME/.local/bin"
PI_AGENT_DIR="$HOME/.pi/agent"
PI_SKILLS_DIR="$HOME/.pi/agent/skills"

mkdir -p "$CONFIG_DIR" "$LOCAL_BIN_DIR" "$PI_AGENT_DIR" "$PI_SKILLS_DIR"

link_path() {
	local source="$1"
	local target="$2"

	rm -rf "$target"
	ln -s "$source" "$target"
}

for NAME in "${CONFIG_LIST[@]}"; do
	link_path "$DOTFILES_DIR/config/$NAME" "$CONFIG_DIR/$NAME"
done

# List of files to symlink
link_path "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
link_path "$DOTFILES_DIR/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
link_path "$DOTFILES_DIR/zsh/.p10k_simple.zsh" "$HOME/.p10k_simple.zsh"
link_path "$DOTFILES_DIR/zsh/.p10k_complex.zsh" "$HOME/.p10k_complex.zsh"
link_path "$DOTFILES_DIR/zsh/.zshrc.pre-oh-my-zsh" "$HOME/.zshrc.pre-oh-my-zsh"

link_path "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
link_path "$DOTFILES_DIR/.bash_prompt" "$HOME/.bash_prompt"
link_path "$DOTFILES_DIR/.pi/agent/settings.json" "$PI_AGENT_DIR/settings.json"
link_path "$DOTFILES_DIR/.pi/agent/extensions" "$PI_AGENT_DIR/extensions"
link_path "$DOTFILES_DIR/.pi/skills" "$PI_SKILLS_DIR"

link_path "$DOTFILES_DIR/bin/zellij_sessionizer" "$LOCAL_BIN_DIR/zellij_sessionizer"
link_path "$DOTFILES_DIR/scripts/open-github.bash" "$LOCAL_BIN_DIR/open-github.bash"
