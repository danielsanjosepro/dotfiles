#!/usr/bin/env python3
import os


repos = [
    "--depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
]

for repo in repos:
    os.system(f"git clone {repo}")
