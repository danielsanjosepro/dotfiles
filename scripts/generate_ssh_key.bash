#!/bin/bash

ssh-keygen -t ed25519 -C "daniel@pokeandwiggle"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519_pw.pub
cat ~/.ssh/id_ed25519_pw.pub | wl-copy
