#!/bin/bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

PI_AGENT_DIR="$HOME/.pi/agent"
PI_EXTENSIONS_DIR="$HOME/.pi/agent/extensions"
PI_SKILLS_DIR="$HOME/.pi/agent/skills"

mkdir -p "$PI_AGENT_DIR" 
mkdir -p "$PI_EXTENSIONS_DIR"

link_path() {
	local source="$1"
	local target="$2"

	rm -rf "$target"
	ln -s "$source" "$target"
}

echo "Linking Pi config..."
link_path "$DOTFILES_DIR/config/pi/agent/settings.json" "$PI_AGENT_DIR/settings.json" && echo "  settings.json"
link_path "$DOTFILES_DIR/config/pi/skills"              "$PI_SKILLS_DIR"              && echo "  skills"

echo "Cloning Pi extensions..."
POKEMON_REPO="git@github.com:danielsanjosepro/pi-pokemon.git"
POKEMON_DIR="$PI_EXTENSIONS_DIR/pokemon-header"
if [ -d "$POKEMON_DIR/.git" ]; then
	echo "  pokemon-header (already cloned)"
elif git clone "$POKEMON_REPO" "$POKEMON_DIR" 2>/dev/null; then
	echo "  pokemon-header"
else
	echo "  WARNING: Could not clone pokemon-header."
	echo "           Make sure you have SSH access to $POKEMON_REPO"
fi

echo "Done."
