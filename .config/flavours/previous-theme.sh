#!/bin/sh
dir=$(readlink -f "$0" | xargs dirname)
themes="${dir}/theme-list.txt"
current=$(head --lines=1 "${dir}/current-theme.txt")
line=$(sed -n "/${current}/=" "${themes}")
next=$(tail --lines=1 "${themes}")
if [ -n "$line" ]; then
    line=$((line - 1))
    line=$(sed -n "${line}p" "${themes}")
fi
if [ -n "$line" ]; then
    next=${line}
fi
echo "${next}" >"${dir}/current-theme.txt"
flavours apply "${next}"
