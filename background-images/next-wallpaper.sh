#!/bin/sh
dir=$(readlink -f "$0" | xargs dirname)
wallpapers="${dir}/wallpaper-list.txt"
current=$(head --lines=1 "${dir}/current-wallpaper.txt")
line=$(sed -n "/${current}/=" "${wallpapers}")
next=$(head --lines=1 "${wallpapers}")
if [ -n "$line" ]; then
    line=$((line + 1))
    line=$(sed -n "${line}p" "${wallpapers}")
fi
if [ -n "$line" ]; then
    next=${line}
fi
echo "${next}" >"${dir}/current-wallpaper.txt"
"${dir}/reload-wallpaper.sh"
