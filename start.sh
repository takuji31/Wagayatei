#!/bin/zsh
start_server  --interval=10 --port=5555 -- plackup -s Starlet -I ./lib -R ./
