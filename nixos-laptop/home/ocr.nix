{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    # https://discourse.nixos.org/t/write-scripts-in-home-manager/60320
    (writeShellApplication {
      name = "ocr"; # this will be the name of the binary
      runtimeInputs = [
        grim # Grab images
        slurp # Select regions
        tesseract # The OCR engine
        wl-clipboard # For clipboard support
      ]; # Dependencies go here
      # Note that no shebang is necessary, writeShellApplication will prepend
      # it.
      #
      # Also note that there is no need to reference the package, the
      # runtimeInputs will take care of adding `bin` directory to this script's
      # path
      text = ''
        export LANG=en_US.UTF-8
        lang=''${1:-eng+deu+lat+grc}
        grim -g "$(slurp)" - | tesseract -l "$lang" - - | wl-copy
      '';
    })
  ];
  wayland.windowManager.sway = {
    config = rec {
      # use lib.mkOptionDefault to merge with default keybindings
      # otherwise all the defaults are removed
      keybindings =
        let
          modifier = config.wayland.windowManager.sway.config.modifier;
        in
        lib.mkOptionDefault {
          "${modifier}+shift+o" = "exec ocr";
          "${modifier}+shift+n" = "exec ocr eng";
          "${modifier}+shift+d" = "exec ocr deu";
          "${modifier}+shift+f" = "exec ocr lat";
          "${modifier}+shift+g" = "exec ocr grc";
        };
    };
  };
  # These hotkeys only seem to work while Emacs is focused.
  # Maybe that has to do with X11 versus Wayland.
  services.sxhkd = {
    enable = true;
    keybindings = {
      "super + shift + o" = "ocr";
      "super + shift + e" = "ocr eng";
      "super + shift + d" = "ocr deu";
      "super + shift + f" = "ocr lat";
      "super + shift + g" = "ocr grc";
    };
  };
  # Ensure sxhkd runs as a systemd user service
  systemd.user.services.sxhkd = {
    Unit = {
      Description = "Simple X hotkey daemon";
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.sxhkd}/bin/sxhkd";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ]; # Starts with GUI
    };
  };
  # desktop shortcuts
  xdg.desktopEntries = {
    "ocr" = {
      name = "OCR";
      exec = "ocr";
    };
  };
  xdg.desktopEntries = {
    "ocr-eng" = {
      name = "OCR English";
      exec = "ocr eng";
    };
  };
  xdg.desktopEntries = {
    "ocr-deu" = {
      name = "OCR German";
      exec = "ocr deu";
    };
  };
  xdg.desktopEntries = {
    "ocr-lat" = {
      name = "OCR Latin";
      exec = "ocr lat";
    };
  };
  xdg.desktopEntries = {
    "ocr-grc" = {
      name = "OCR Ancient Greek";
      exec = "ocr grc";
    };
  };
}
