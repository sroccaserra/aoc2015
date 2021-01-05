#!/usr/bin/env bash

tr '{}[], ":abcdefghiklmnopqrstuvwxyz' ' ' <src/12.txt \
    | tr -s ' ' \
    | tr ' ' '\n' \
    | awk '{ s += $1 } END { print s }'
