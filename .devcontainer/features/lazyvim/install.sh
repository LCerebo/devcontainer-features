#!/bin/bash
set -e

echo "Installing lazyvim configuration"
target_user="${_REMOTE_USER:-${USER}}"
target_home="${_REMOTE_USER_HOME:-${HOME}}"
required_tools="git curl gcc make trash-cli ghostscript texlive-latex-base"

check_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "$1 is not available;" >&2
    return 1
  fi
  return 0
}

install_missing_tools() {
  declare -a missing_tools=()
  for tool in ${required_tools}; do
    if ! check_command "${tool}"; then
      missing_tools+=("${tool}")
    fi
  done
  if [ ${#missing_tools[@]} -gt 0 ]; then
    if check_command "apt-get"; then
      echo "Installing missing tools: '${missing_tools[*]}'"
      apt-get update
      apt-get install -y --no-install-recommends "${missing_tools[@]}"
      rm -rf /var/lib/apt/lists/*
    else
      echo "apt-get missing, can't install missing tools: '${missing_tools[*]}'." >&2
      exit 1
    fi
  fi
}

install_missing_tools

npm install -g tree-sitter-cli @mermaid-js/mermaid-cli

git clone https://github.com/LazyVim/starter "${target_home}/.config/nvim"
rm -rf "${target_home}/.config/nvim/.git"

chown -R "${target_user}:${target_user}" "${target_home}/.config/nvim"
