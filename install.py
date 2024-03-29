#!/bin/python3

import os
import argparse

# Parse command line arguments
parser = argparse.ArgumentParser(description='Install dotfiles')
# Add argument for arch linux
parser.add_argument('--arch', action='store_true', help='Install for Arch Linux', required=False, default=False)

args = parser.parse_args()

# Check if user is running as root
if os.geteuid() != 0:
    print('Please run as root')
    exit()
    

# Current directory
current_dir = os.getcwd()


# copy .bashrc to home directory
print('Copying .bashrc to home directory...')
os.system('cp ' + current_dir + '/scripts/.bashrc ' + os.path.expanduser('~'))

# copy .bash_prompt to home directory
print('Copying .bash_prompt to home directory...')
os.system('cp ' + current_dir + '/scripts/.bash_prompt ' + os.path.expanduser('~'))

# Install arch specific packages
if args.arch:
    print('Installing arch specific packages...')
    print('Installing yay...')
    os.system('bash ' + current_dir + '/install_yay.bash')

print('Done!')
