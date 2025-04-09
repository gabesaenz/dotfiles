#!/bin/sh
gowall convert --batch ~/dotfiles/background-images/current.jpg --format jpg --theme ~/dotfiles/background-images/gowall-base16-theme.json
cp ~/Pictures/gowall/current.jpg ~/Pictures/gowall/dummy
automator -i ~/Pictures/gowall/dummy ~/dotfiles/background-images/setWallpaper.workflow
automator -i ~/Pictures/gowall/current.jpg ~/dotfiles/background-images/setWallpaper.workflow
