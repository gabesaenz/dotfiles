#!/bin/sh
dir=$(readlink -f "$0" | xargs dirname)
flavours apply
flavours current >"${dir}/current-theme.txt"
