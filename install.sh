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
cp init.el ~/.emacs.d/
mkdir ~/.emacs.d/lisp
wget -P ~/.emacs.d/lisp https://raw.githubusercontent.com/TechMagister/emacs-crystal-mode/master/crystal-mode.el

echo ""

if ! [[ -x "$(command -v emacs)" ]]; then
  echo "emacs not found. Is it installed?" >&2
  exit
fi

echo "Install dependencies:"
sudo apt-get install libclang-dev cmake
./emacs_pkgs.el

mkdir /tmp/irony
cd /tmp/irony
cmake -DCMAKE_INSTALL_PREFIX\=~/.emacs.d/irony/ `find ~/.emacs.d/elpa -maxdepth 1 -type d -name 'irony*'`/server && cmake --build . --use-stderr --config Release --target install
rm -rf /tmp/irony

################
# GPG
################
cp gpg.conf gpg-agent.conf ~/
