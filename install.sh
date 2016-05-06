#!/usr/bin/env bash

################
# Atom
################
cp -avr .atom ~/
echo ""

if ! [[ -x "$(command -v apm)" ]]; then
  echo "Atom packet manager (apm) not found. Is it installed?" >&2
  exit
fi

apm install autocomplete-paths

################
# Emacs
################
cp .emacs ~/
# echo ""

if ! [[ -x "$(command -v emacs)" ]]; then
  echo "emacs not found. Is it installed?" >&2
  exit
fi

sudo apt-get install libclang-dev
./emacs_pkgs.el

mkdir /tmp/irony
cd /tmp/irony
cmake -DCMAKE_INSTALL_PREFIX\=~/.emacs.d/irony/ `find ~/.emacs.d/elpa -maxdepth 1 -type d -name 'irony*'`/server && cmake --build . --use-stderr --config Release --target install
rm -rf /tmp/irony
