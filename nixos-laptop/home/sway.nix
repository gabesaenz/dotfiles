{ config, pkgs, ... }:
{
  # Sway WM
  services.gnome-keyring.enable = true;
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # Fixes common issues with GTK 3 apps
    config = rec {
      modifier = "Mod4";
      # default terminal
      terminal = "alacritty";
      startup = [
        # Launch Firefox on start
        { command = "firefox"; }
      ];
    };
  };
}
