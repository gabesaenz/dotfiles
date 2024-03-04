#!/bin/sh
themes="theme-list.txt"
current=$(flavours current)
line=$(sed -n "/${current}/=" ${themes})
next=$(head --lines=1 ${themes})
if [ -n "$line" ]; then
    line=$((line + 1))
    line=$(sed -n "${line}p" ${themes})
fi
if [ -n "$line" ]; then
    next=${line}
fi
flavours apply "${next}"
