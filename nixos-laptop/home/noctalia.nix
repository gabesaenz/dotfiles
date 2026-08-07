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
          # refresh the avatar
          noctalia msg config-reload
          # sync the greeter config
          noctalia msg greeter-sync
        '';
      }
    )
  ];
  ### Wallpaper and Avatar theming
  xdg.configFile."noctalia/templates/gowall.yml".text = ''
    themes:
      - name: "noctalia"
        colors:
          <* for tone in palettes.primary *>
          - "{{ tone.default.hex }}"
          <* endfor *>
  '';
  xdg.configFile."noctalia/templates.toml".text = ''
    [theme.templates.user.gowall]
    input_path  = "$XDG_CONFIG_HOME/noctalia/templates/gowall.yml"
    output_path = "$XDG_CONFIG_HOME/gowall/config.yml"
    post_hook   = "update-noctalia-wallpapers-and-avatars"
  '';
  doom-config = {
    config = "(setq doom-theme 'noctalia)";
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
