export PATH="/opt/homebrew/bin:/usr/local/bin:${PATH}"
export LANG=en_US.UTF-8
lang=${1:-eng+deu+lat+grc}
dir=~/ocr-snapshots
# slug=$(date +-%Y-%m-%d-%H-%M-%S)
slug=''

screencapture -i "$dir/ocr_snapshot$slug.png"

tesseract --dpi 300 "$dir/ocr_snapshot$slug.png" - -l "$lang" | pbcopy
