#!/bin/sh
nvr --serverlist |
    while read line; do
        nvr --nostart -cc ':colorscheme flavours' --servername $line &
    done
