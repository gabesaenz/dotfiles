export LANG=en_US.UTF-8
lang=${1:-eng+deu+lat+grc}
grim -g "$(slurp)" - | tesseract -l "$lang" - - | wl-copy

# export LANG=en_US.UTF-8
# lang=${1:-eng+deu+lat+grc}
# dir=~/ocr-snapshots
# grim -g "$(slurp)" "$dir/ocr_snapshot.png"
# tesseract "$dir/ocr_snapshot.png" - -l "$lang" | wl-copy
