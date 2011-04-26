#!/bin/zsh
env CHIFFON_APP_ENV=dev plackup -s Starlet -I ./lib -R ./ --port=5555
