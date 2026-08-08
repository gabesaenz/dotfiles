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

  programs.foot = {
    settings = {
      main = {
        include = "${config.xdg.configHome}/foot/dank-colors.ini";
      };
    };
  };

  programs.ghostty = {
    settings = {
      theme = "dankcolors";
    };
  };

  doom-config = {
    config = "(setq doom-theme 'dank-emacs)";
  };

  xdg.configFile."niri/config.kdl".text = ''
    // import DankMaterialShell settings
    include "dms.kdl"
  '';
  xdg.configFile.noctalia-niri-config = {
    source = ./niri/dms.kdl;
    target = "niri/dms.kdl";
  };
}
