#!/usr/bin/env bash

ROOT=/var/lib/cloudway/plugins/_

for d in *; do
    if [ -f $d/manifest/plugin.yml ]; then
        ver=$(sed -e '/^Version:/!d' -e "s/^Version: '\\(.*\\)'$/\\1/" $d/manifest/plugin.yml)
        rm -rf $ROOT/$d/$ver
        mkdir -p $ROOT/$d/$ver
        cp -R $d/* $ROOT/$d/$ver/
    fi
done
