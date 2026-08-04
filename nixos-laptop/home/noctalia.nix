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
  programs.btop = {
    settings = {
      color_theme = "noctalia";
    };
  };
  programs.helix = {
    settings = {
      theme = "noctalia";
    };
  };
  programs.foot = {
    settings = {
      main = {
        include = "${config.xdg.configHome}/foot/themes/noctalia";
      };
    };
  };
  programs.bat = {
    config = {
      theme = "noctalia";
    };
  };
}
