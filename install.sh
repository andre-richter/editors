#!/usr/bin/env bash

#
# Tested only with Ubuntu 16.04 Desktop
#

echo ""

if ! [[ -x "$(command -v emacs)" ]]; then
  echo "emacs not found. Is it installed?" >&2
  exit
fi

rm -rf ~/.emacs.d
rm ~/.emacs.d/init.el

mkdir ~/.emacs.d
ln -s ~/repos/editors/init.el ~/.emacs.d/init.el
mkdir ~/.emacs.d/lisp

echo "Install dependencies:"

# Rust
curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain nightly
$HOME/.cargo/bin/rustup component add rust-src
$HOME/.cargo/bin/cargo install racer

# C/C++
sudo apt-get install clang libclang-dev global cmake xclip
./emacs_pkgs.el

mkdir /tmp/irony
cd /tmp/irony
cmake -DCMAKE_INSTALL_PREFIX\=~/.emacs.d/irony/ `find ~/.emacs.d/elpa -maxdepth 1 -type d -name 'irony*'`/server && cmake --build . --use-stderr --config Release --target install
rm -rf /tmp/irony
