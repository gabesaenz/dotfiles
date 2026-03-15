{
  config,
  pkgs,
  lib,
  ...
}:
{
  # Sway WM
  # https://wiki.nixos.org/wiki/Sway
  services.gnome-keyring.enable = true;
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # Fixes common issues with GTK 3 apps
    config = rec {
      modifier = "Mod4"; # Super key
      # default terminal
      terminal = "alacritty";
      startup = [
        # Launch Firefox on start
        { command = "firefox"; }
      ];
      input = {
        "type:touchpad" = {
          # Enables or disables tap for specified input device.
          tap = "enabled";
          # Enables or disables natural (inverted) scrolling for the specified input device.
          natural_scroll = "enabled";
          # Enables or disables disable-while-typing for the specified input device.
          dwt = "enabled";
        };
      };
      seat = {
        "*" = {
          # hide mouse cursor after 2 seconds idle
          hide_cursor = "2000";
          # hide mouse cursor when typing
          # hide_cursor = "when-typing enable";
        };
      };
      # use lib.mkOptionDefault to merge with default keybindings
      # otherwise all the defaults are removed
      keybindings =
        let
          modifier = config.wayland.windowManager.sway.config.modifier;
        in
        lib.mkOptionDefault {
          # Emacs
          "${modifier}+e" = "exec ${config.home.homeDirectory}/dotfiles/emacsclient.sh";
          ### Audio and brightness controls and similar
          # Audio Volume Controls (Sink - Output)
          "XF86AudioRaiseVolume" = "exec swayosd-client --output-volume raise";
          "XF86AudioLowerVolume" = "exec swayosd-client --output-volume lower";
          "XF86AudioMute" = "exec swayosd-client --output-volume mute-toggle";

          # Microphone Volume Control (Source - Input)
          "XF86AudioMicMute" = "exec swayosd-client --input-volume mute-toggle";

          # Caps Lock
          "--release Caps_Lock" = "exec swayosd-client --caps-lock";

          # Brightness Controls
          "XF86MonBrightnessUp" = "exec swayosd-client --brightness raise";
          "XF86MonBrightnessDown" = "exec swayosd-client --brightness lower";

          # Media Player Controls
          "XF86AudioPlay" = "exec swayosd-client --playerctl play-pause";
          "XF86AudioNext" = "exec swayosd-client --playerctl next";
        };
    };
  };
  services.swayosd = {
    enable = true;
    # OSD Margin from the top edge, 0.5 would be the screen center. May be from 0.0 - 1.0.
    topMargin = 0.9;
    # For a custom stylesheet file.
    #stylePath = "/etc/xdg/swayosd/style.css";
  };
  programs.waybar.enable = true;
}
