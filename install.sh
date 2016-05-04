#!/usr/bin/env bash

# Atom stuff
cp -avr .atom ~/
echo ""

if ! [[ -x "$(command -v apm)" ]]; then
  echo "Atom packet manager (apm) not found. Is Atom installed?" >&2
  exit
fi

apm install autocomplete-paths
