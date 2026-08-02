{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    pywalfox-native # required for Firefox theming through DMS
  ];

  # required for Firefox theming through DMS
  home.file.".cache/wal/colors.json".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.cache/wal/dank-pywalfox.json";
}
