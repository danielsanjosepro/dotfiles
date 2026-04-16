#!/bin/bash

# Post-install script for Arch Linux desktop setup
# Based on manually executed commands after a fresh install

set -e

echo "==> Installing pacman packages..."
sudo pacman -S --noconfirm \
    wl-clipboard \
    hyprpolkitagent \
    hyprlauncher \
    firefox \
    imv

echo "==> Installing yay packages..."
yay -S --noconfirm \
    wezterm \
    waybar \
    spotify \
    ttf-jetbrains-mono-nerd \
    fish \
    starship \
    direnv \
    pipewire \
    pavucontrol \
    iwgtk \
    impala

echo "==> Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

echo "==> Installing brew packages..."
brew install node

echo "==> Installing Claude Code..."
curl -fsSL https://claude.ai/install.sh | bash

echo "==> Installing pixi..."
curl -fsSL https://pixi.sh/install.sh | sh

echo"==> Ensuring ~/.local/bin is in PATH..."
if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' ~/.bashrc 2>/dev/null; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
fi

echo "==> Changing default shell to fish..."
chsh -s /usr/bin/fish

echo "==> Done! Please log out and back in for shell change to take effect."
