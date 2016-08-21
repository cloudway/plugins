#!/usr/bin/env bash

for d in *; do
    if [ -f $d/manifest/plugin.yml ]; then
        img=$(sed -e '/^Base-Image:/!d' -e 's/^Base-Image: \(.*\)$/\1/' $d/manifest/plugin.yml)
        if ! docker inspect "$img" &>/dev/null; then
            docker pull "$img"
        fi
    fi
done
