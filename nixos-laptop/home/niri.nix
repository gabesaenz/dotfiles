{
  config,
  pkgs,
  lib,
  ...
}:
{
  xdg.configFile."niri/config.kdl".text = builtins.readFile ./niri/config.kdl;
}
