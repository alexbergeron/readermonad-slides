#!/bin/sh

~/.cabal/bin/pandoc -f markdown --atx-headers -t revealjs --slide-level=2 --template template.html -o readermonad.html readermonad.md
