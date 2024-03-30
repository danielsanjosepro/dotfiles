#!/usr/bin/env python3
import os


files_to_save = [
    ".p10k_complex.zsh",
    ".p10k_simple.zsh",
    ".p10k.zsh",
    ".zshrc",
    ".zshrc.pre-oh-my-zsh",
]

for file in files_to_save:
    os.system(f"cp ~/{file} ~/git/dotfiles/zsh/")
