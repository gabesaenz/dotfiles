{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    ### Firefox theming
    # - install firefox pywalfox extension
    # - run "pywalfox install"
    # - enable theming template
    pywalfox-native
  ];
}
