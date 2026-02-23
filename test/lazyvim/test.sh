#!/bin/bash

set -e

source dev-container-features-test-lib

config_home="${_REMOTE_USER_HOME:-${HOME}}"

check "config directory exists" test -d "${config_home}/.config/nvim"
check "lazyvim files present" test -f "${config_home}/.config/nvim/lua/config/lazy.lua"
check "git metadata removed" test ! -d "${config_home}/.config/nvim/.git"
check "nvim config not owned by root" bash -c "[ \"\$(stat -c '%U' '${config_home}/.config/nvim')\" != 'root' ]"

reportResults
