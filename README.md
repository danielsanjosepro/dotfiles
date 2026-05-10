# Daniel's dotfiles 📂

This repository maintains my scripts and configuration files for my desktop environment. It is a work in progress and is constantly being updated.

It also includes a minimal global `pi` configuration in `.pi/agent/settings.json`, global extensions in `.pi/agent/extensions/`, and reusable skills in `.pi/skills/`.

## Installation

To install the configuration files, clone the repository and run the `install.sh` script.
This also symlinks the pi settings, extensions, and skills into `~/.pi/agent/`.

```bash
git clone git@github.com:danielsanjosepro/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```
