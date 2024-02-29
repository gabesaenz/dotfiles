ls -1fX *.svg | sed 's/.svg//' | xargs -I{} ./svg2icns.sh {}.svg {}
