#!/bin/bash

set -e

source dev-container-features-test-lib

config_home="${_REMOTE_USER_HOME:-${HOME}}"
expected_user="${_REMOTE_USER:-$(id -un)}"

check "config directory exists" test -d "${config_home}/.config/nvim"
check "lazyvim files present" test -f "${config_home}/.config/nvim/lua/config/lazy.lua"
check "git metadata removed" test ! -d "${config_home}/.config/nvim/.git"
check "git installed" command -v git
check "curl installed" command -v curl
check "gcc installed" command -v gcc
check "make installed" command -v make
if [ "${expected_user}" != "root" ]; then
	check "config directory owned by expected user" bash -c "[ \"\$(stat -c '%U' '${config_home}/.config')\" = '${expected_user}' ]"
	check "nvim config owned by expected user" bash -c "[ \"\$(stat -c '%U' '${config_home}/.config/nvim')\" = '${expected_user}' ]"
fi

reportResults
