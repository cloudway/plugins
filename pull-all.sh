#!/usr/bin/env bash

for d in *; do
    if [ -f $d/manifest/plugin.yml ]; then
        img=$(sed -e '/^Base-Image:/!d' -e 's/^Base-Image: \(.*\)$/\1/' $d/manifest/plugin.yml)
        docker pull $img
    fi
done

