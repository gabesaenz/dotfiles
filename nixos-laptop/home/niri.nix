{
  config,
  pkgs,
  lib,
  ...
}:
{
  xdg.configFile."niri/config.kdl".text = builtins.readFile ./niri/config.kdl;
  # xdg.configFile.niri-config = {
  #   source = ./niri;
  #   target = "niri";
  #   recursive = true;
  # };
}
