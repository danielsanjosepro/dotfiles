import os

cmds = [
    "sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)",
]

for cmd in cmds:
    os.system(cmd)
