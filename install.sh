#!/usr/bin/env bash

#
# Tested only with Ubuntu 16.04 Desktop
#

################
# Atom
################
# cp -avr .atom ~/
# echo ""

# if ! [[ -x "$(command -v apm)" ]]; then
#   echo "Atom packet manager (apm) not found. Is it installed?" >&2
#   exit
# fi

# apm install autocomplete-paths

################
# Emacs
################
mkdir ~/.emacs.d
ln -s ~/repos/editors/init.el ~/.emacs.d/init.el
mkdir ~/.emacs.d/lisp

echo ""

if ! [[ -x "$(command -v emacs)" ]]; then
  echo "emacs not found. Is it installed?" >&2
  exit
fi

echo "Install dependencies:"
rustup component add rust-src
cargo install racer

sudo apt-get install clang libclang-dev global cmake xclip
./emacs_pkgs.el

mkdir /tmp/irony
cd /tmp/irony
cmake -DCMAKE_INSTALL_PREFIX\=~/.emacs.d/irony/ `find ~/.emacs.d/elpa -maxdepth 1 -type d -name 'irony*'`/server && cmake --build . --use-stderr --config Release --target install
rm -rf /tmp/irony
