#!/usr/bin/env bash

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

# C/C++
sudo apt-get install clang libclang-dev global cmake xclip
./emacs_pkgs.el

mkdir /tmp/irony
cd /tmp/irony
cmake -DCMAKE_INSTALL_PREFIX\=~/.emacs.d/irony/ `find ~/.emacs.d/elpa -maxdepth 1 -type d -name 'irony*'`/server && cmake --build . --use-stderr --config Release --target install
rm -rf /tmp/irony

echo "!!!!!!!!"
echo "Remember to install One Dark Pro theme for vscode"
echo "!!!!!!!!"
ln -s ~/repos/editors/vscode_settings.json ~/.config/Code/User/settings.json

# Rust
echo "Browse to https://rust-lang.github.io/rustup-components-history and put in the newest date string for which clippy is present. e.g. 2019-07-03"
read version
curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain nightly-$version
$HOME/.cargo/bin/rustup component add      \
			rust-src           \
			llvm-tools-preview \
			rustfmt-preview    \
			clippy-preview

$HOME/.cargo/bin/cargo install        \
		       racer          \
		       cargo-xbuild   \
		       cargo-binutils \
		       ripgrep
