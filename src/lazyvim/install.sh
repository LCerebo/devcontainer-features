#!/bin/sh
set -e

echo "Installing lazyvim configuration"

target_home="${_REMOTE_USER_HOME:-${HOME}}"

git clone https://github.com/LazyVim/starter "${target_home}/.config/nvim"
rm -rf "${target_home}/.config/nvim/.git"
