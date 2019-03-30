#!/usr/bin/env bash

set -e

cd "$(dirname "${BASH_SOURCE}")"

git pull origin master

function brew_all_the_things() {
  if [[ -z "$(command -v brew)" ]]; then
    echo "Installing homebrew..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  echo "Running the Brewfile..."
  brew update
  brew upgrade
  brew tap Homebrew/bundle
  ln -sf "$(pwd)/Brewfile" "${HOME}/.Brewfile"
  brew bundle --global
  brew bundle cleanup
}

function setup_vim() {
  if [[ -d "${HOME}/.vim" ]]; then
    echo "removing ~/.vim dir"
    rm -rf "${HOME}/*.vim"
  else
    echo "Installing luan's vimfiles..."
    curl vimfiles.luan.sh/install | FORCE=1 bash
  fi

  echo "Updating vim..."
  vim-update
}

function setup_fasd() {
  local fasd_cache
  fasd_cache="${HOME}/.fasd-init-bash"

  if [[ "$(command -v fasd)" -nt "$fasd_cache" ]] || [[ ! -s "${fasd_cache}" ]]; then
    fasd --init posix-alias bash-hook bash-ccomp bash-ccomp-install >| "$fasd_cache"
  fi

  source "${fasd_cache}"
  eval "$(fasd --init auto)"
}

function rsync_and_source() {
  rsync --exclude ".git/" \
    --exclude ".DS_Store" \
    --exclude ".macos" \
    --exclude "bootstrap.sh" \
    --exclude "Brewfile" \
    --exclude "LICENSE" \
    --exclude "README.md" \
    -avh --no-perms . ~
  source ~/.bash_profile
}

function do_it() {
  brew_all_the_things
  setup_vim
  setup_fasd
  rsync_and_source
}

function main() {
  if [[ "$1" == "-f" ]]; then
    do_it
  else
    read -rp "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
    echo ""
    if [[ "${REPLY}" =~ ^[Yy]$ ]]; then
      do_it
    fi
  fi
}

main
