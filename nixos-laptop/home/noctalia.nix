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

    ### Wallpaper and Avatar theming update script
    # https://discourse.nixos.org/t/write-scripts-in-home-manager/60320
    (
      let
        wallpapers = {
          source = "${config.home.homeDirectory}/dotfiles/Wallpapers";
          target = "${config.home.homeDirectory}/Pictures/Wallpapers";
        };
        avatars = {
          source = "${config.home.homeDirectory}/dotfiles/Avatars";
          target = "${config.home.homeDirectory}/Pictures/Avatars";
        };
        theme = "noctalia";
      in
      writeShellApplication {
        name = "update-noctalia-wallpapers-and-avatars"; # this will be the name of the binary
        runtimeInputs = [
          gowall # convert image palettes
        ]; # Dependencies go here
        # Note that no shebang is necessary, writeShellApplication will prepend
        # it.
        #
        # Also note that there is no need to reference the package, the
        # runtimeInputs will take care of adding `bin` directory to this script's
        # path
        text = ''
          current_wallpaper=$(noctalia msg wallpaper-get)
          tmp_image="/tmp/gowall-tmp-image"
          rm --force "$tmp_image"
          cp "$current_wallpaper" "$tmp_image"
          noctalia msg wallpaper-set "$tmp_image"
          gowall convert --dir "${wallpapers.source}" --theme "${theme}" --output "${wallpapers.target}"
          gowall convert --dir "${avatars.source}" --theme "${theme}" --output "${avatars.target}"
          noctalia msg wallpaper-set "$current_wallpaper"
          sleep 10
          # refresh the avatar
          noctalia msg config-reload
          # sync the greeter config
          noctalia msg greeter-sync
        '';
      }
    )
    ### Theme switcher
    (writeShellApplication {
      name = "theme-switcher-noctalia";
      text = ''
        direction=$1
        current_theme=$(noctalia msg color-scheme-get)
        themes="${config.home.homeDirectory}/theme-list"
        next_line=$(sed -n "/''${current_theme}/=" "''${themes}")
        next_theme=$(head --lines=1 "''${themes}")
        if [ -n "$next_line" ]; then
          next_line=$((next_line + 1))
          next_line=$(sed -n "''${next_line}p" "''${themes}")
        fi
        if [ -n "$next_line" ]; then
          next_theme=''${next_line}
        fi
        previous_line=$(sed -n "/''${current_theme}/=" "''${themes}")
        previous_theme=$(tail --lines=1 "''${themes}")
        if [ "$previous_line" == 1 ]; then
          previous_line=""
        fi
        if [ -n "$previous_line" ]; then
          previous_line=$((previous_line - 1))
          previous_line=$(sed -n "''${previous_line}p" "''${themes}")
        fi
        if [ -n "$previous_line" ]; then
          previous_theme=''${previous_line}
        fi
        if [ "$direction" == "next" ]; then
          current_theme="$next_theme"
        fi
        if [ "$direction" == "previous" ]; then
          current_theme="$previous_theme"
        fi
        noctalia msg color-scheme-set "$current_theme"
      '';
    })
  ];
  ### Wallpaper and Avatar theming
  xdg.configFile."noctalia/templates/gowall.yml".text = ''
    themes:
      - name: "noctalia"
        colors:
          - "{{colors.surface.default.hex}}"
          - "{{colors.surface_container.default.hex}}"
          - "{{colors.surface_container_high.default.hex}}"
          - "{{colors.outline.default.hex}}"
          - "{{colors.on_surface_variant.default.hex}}"
          - "{{colors.on_surface.default.hex}}"
          - "{{colors.on_surface.default.hex}}"
          - "{{colors.on_background.default.hex}}"
          - "{{colors.error.default.hex}}"
          - "{{colors.tertiary.default.hex}}"
          - "{{colors.secondary.default.hex}}"
          - "{{colors.primary.default.hex}}"
          - "{{colors.tertiary_fixed_dim.default.hex}}"
          - "{{colors.primary_fixed_dim.default.hex}}"
          - "{{colors.secondary_fixed_dim.default.hex}}"
          - "{{colors.error_container.default.hex}}"
  '';
  xdg.configFile."noctalia/templates.toml".text = ''
    [theme.templates.user.gowall]
    input_path  = "$XDG_CONFIG_HOME/noctalia/templates/gowall.yml"
    output_path = "$XDG_CONFIG_HOME/gowall/config.yml"
    post_hook   = "update-noctalia-wallpapers-and-avatars"
  '';
  home.file."theme-list".text = ''
    builtin Eldritch
    builtin Nord
    builtin Catppuccin
    builtin Noctalia
    builtin Gruvbox
    builtin Rosé Pine
    community Cream Autumn
    community Everdeer
    community Everforest
  '';
  doom-config = {
    config = "(setq doom-theme 'noctalia)";
  };
  xdg.configFile."niri/config.kdl".text = ''
    // import Noctalia theme
    // the filename is decided by noctalia
    // so the personal settings file needs a different name
    // and the include needs to be written here
    // since home-manager creates a symlink that
    // noctalia can't edit
    // since this file is not there until noctalia adds it
    // it could cause issues with validating the config
    // not sure what to do about that at the moment
    include "noctalia.kdl"

    // import Noctalia settings
    include "noctalia-settings.kdl"
  '';
  xdg.configFile.noctalia-niri-config = {
    source = ./niri/noctalia-settings.kdl;
    target = "niri/noctalia-settings.kdl";
  };
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
  programs.ghostty = {
    settings = {
      theme = "noctalia";
    };
  };
  programs.bat = {
    config = {
      theme = "noctalia";
    };
  };
}
