{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
      # doom-emacs dependencies
      git
      ripgrep
      coreutils # optional
      fd # optional
      fontconfig # added because of doom doctor warning
  ];

  # Fonts
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    # Devanagari
    annapurna-sil
    # nerd fonts
    (nerdfonts.override { fonts = [ "Noto" "FiraCode" ]; })
    # doom-emacs
    emacs-all-the-icons-fonts
  ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  programs.fish.enable = true;

  # services.yabai.enable = true;
  # services.yabai.package = pkgs.yabai;
  # services.skhd.enable = true;

  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    enableScriptingAddition = true;
    config = {
      focus_follows_mouse          = "autoraise";
      mouse_follows_focus          = "off";
      window_placement             = "second_child";
      window_opacity               = "off";
      window_opacity_duration      = "0.0";
      window_border                = "on";
      window_border_placement      = "inset";
      window_border_width          = 2;
      window_border_radius         = 10;
      active_window_border_topmost = "off";
      window_topmost               = "on";
      window_shadow                = "float";
      active_window_border_color   = "0xff5c7e81";
      normal_window_border_color   = "0xff505050";
      insert_window_border_color   = "0xffd75f5f";
      active_window_opacity        = "1.0";
      normal_window_opacity        = "1.0";
      split_ratio                  = "0.50";
      auto_balance                 = "on";
      mouse_modifier               = "fn";
      mouse_action1                = "move";
      mouse_action2                = "resize";
      layout                       = "bsp";
      top_padding                  = 2;
      bottom_padding               = 2;
      left_padding                 = 2;
      right_padding                = 2;
      window_gap                   = 2;
    };

    extraConfig = ''
        # rules
        yabai -m rule --add app='System Preferences' manage=off

        # Any other arbitrary config here
      '';
  };

  homebrew.enable = true;
  homebrew.taps = [ "homebrew/cask" "railwaycat/emacsmacport" ];
  homebrew.brews = [
    {
      name = "emacs-mac";
      args = [ "with-modules" "with-native-compilation" ];
      # restart_service = true;
      # link = true; # default behavior should work?
    }
  ];
  homebrew.casks = [
    "adobe-acrobat-reader" # work
    "alacritty"
    "dropbox"
    "firefox"
    "google-chrome"
    "spotify"
  ];
  # homebrew.onActivation.cleanup = "uninstall";
  # homebrew.onActivation.upgrade = true;

  # Home Manager
  imports = [ <home-manager/nix-darwin> ];

  users.users.gabesaenz = {
    name = "Gabe Saenz";
    home = "/Users/gabesaenz";
  };
  home-manager.users.gabesaenz = { pkgs, ... }: {
    home.stateVersion = "22.05";
    home.packages = with pkgs; [
      exa
      bat
      # adobe-reader # i686 Linux package (not supported) 2023-01-23
      # neovide
      # alacritty
      # firefox # not supported on darwin 2023-01-22
      # rustup
      # rustdesk # not supported on darwin 2022-12-02
      # pomotroid # not supported on darwin 2022-12-12
    ];
    programs.starship.enable = true;
    programs.fish.enable = true;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
