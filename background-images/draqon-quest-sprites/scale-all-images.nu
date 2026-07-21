#! /usr/bin/env nix
#! nix shell nixpkgs#nushell nixpkgs#imagemagick --command nu
def scale-image [filename factor destination] {
  let input = $"($filename)"
  let options = $"-sample ($factor)00% -background none"
    | split row ' '
    | collect
  let output = $"($destination)/($filename)"
  let args = [$input ...$options $output]
  ^magick ...$args
}

# Scale all PNG images in the current directory by a given factor.
#
# The scaled images are saved in a subdirectory which has a name based on the scale factor.
def main [--factor: int = 4]: nothing -> nothing {
  let destination = $"scaled-x($factor)"
  let extensions = [png gif]

  mkdir $destination

  ls
  | where ($in.name | path parse | get extension | str downcase) in $extensions
  | get name
  | each {|filename| scale-image $filename $factor $destination }

  return
}
