#!/bin/sh
dir=$(readlink -f "$0" | xargs dirname)
gowall_dir="$HOME/Pictures/gowall"
current=$(head --lines=1 "${dir}/current-wallpaper.txt")
gowall convert --batch "${dir}/${current}" --theme "${dir}/gowall-base16-theme.json"
cp "${gowall_dir}/${current}" "${gowall_dir}/dummy-${current}"
automator -i "${gowall_dir}/dummy-${current}" "${dir}/setWallpaper.workflow"
automator -i "${gowall_dir}/${current}" "${dir}/setWallpaper.workflow"
