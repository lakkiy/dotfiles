#!/bin/bash

curl -L -O https://github.com/rime/librime/releases/download/1.7.2/rime-1.7.2-osx.zip
unzip rime-1.7.2-osx.zip -d ~/.config/emacs/librime
rm -rf rime-1.7.2-osx.zip
