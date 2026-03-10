{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    w3m
  ];
  xdg.configFile."doom/packages.el" = {
    text = ''
      ;; w3m web browser
      ;; (package! w3m)
    '';
  };
  xdg.configFile."doom/config.el" = {
    text = ''
      ;; w3m web browser config
    '';
  };
}
