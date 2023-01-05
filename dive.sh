#!/usr/bin/env sh
TAG=$1

if [ ! -f /usr/local/bin/dive ]; then
    docker run --rm -it \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v "$(pwd)":"$(pwd)" \
        -w "$(pwd)" \
        -v "$HOME/.dive.yaml":"$HOME/.dive.yaml" \
        wagoodman/dive:$TAG build -t captain-proton/docker-manjaro-ansible .
else
    dive captain-proton/docker-manjaro-ansible:$TAG
fi
