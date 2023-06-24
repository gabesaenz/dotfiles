{ config, pkgs, ... }:

{
  # Nix settings

  # Channels
  # darwin https://github.com/LnL7/nix-darwin/archive/master.tar.gz
  # home-manager https://github.com/nix-community/home-manager/archive/master.tar.gz
  # nixpkgs https://nixos.org/channels/nixpkgs-unstable
  # Update them with: nix-channel --update
  # Also update the root channels with: sudo -i nix-channel --update

  # Use a custom configuration.nix location.
  # see: https://github.com/LnL7/nix-darwin/wiki/Changing-the-configuration.nix-location
  # Run this the first time:
  # darwin-rebuild switch -I darwin-config=$HOME/dotfiles/nix/mac/darwin-configuration.nix
  # Then run this any time after that:
  # nix-channel --update;darwin-rebuild switch
  environment.darwinConfig = "$HOME/dotfiles/nix/mac/darwin-configuration.nix";

  # Optimize the store
  # https://nixos.wiki/wiki/Storage_optimization#Optimising_the_store
  nix.settings.auto-optimise-store = true;

  # Garbage collection
  # https://nixos.wiki/wiki/Storage_optimization#Automation
  # Also run these commands to manually clean up garbage:
  # nix-collect-garbage -d
  # sudo nix-collect-garbage -d
  nix.gc = {
    automatic = true;
    interval = { Weekday = 0; Hour = 0; Minute = 0; };
    options = "--delete-older-than 30d";
  };
  nix.extraOptions = ''
  min-free = ${toString (100 * 1024 * 1024)}
  max-free = ${toString (1024 * 1024 * 1024)}
  '';

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  # Enable nix command
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  programs.fish.enable = true;
  environment.shells = with pkgs; [ fish ];

  # Networking
  networking.hostName = "Gabe-Mac"; # Define your hostname.

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

  services.skhd = {
    enable = true;
    skhdConfig = ''
      # open terminal
      cmd - return : alacritty

      # emacs
      cmd - e : emacsclient -c -a ""
    '';
  };

  homebrew.enable = true;
  homebrew.taps = [
    "homebrew/cask"
    "homebrew/services"
    "railwaycat/emacsmacport"
  ];
  homebrew.brews = [
    {
      name = "emacs-mac";
      args = [
        "with-dbus"
        "with-glib"
        "with-imagemagick"
        "with-librsvg"
        "with-native-compilation"
        "with-no-title-bars"
        "with-modules" # not sure if this is necessary
      ];
      # restart_service = true; # this doesn't have a service
      # start_service = true; # this doesn't have a service
      # link = true; # default behavior should work?
    }
  ];
  homebrew.casks = [
    "adobe-acrobat-reader" # work
    "alacritty" # terminal emulator
    "dropbox" # cloud storage
    "firefox" # web browser
    "flux" # nighttime colorshift
    "google-chrome" # web browser
    "libreoffice" # work
    "noisy" # whitenoise generator
    "the-unarchiver" # archive manager
    "spotify" # music streaming
    "telegram" # messaging
    "vitalsource-bookshelf" # textbook ebook reader
    "vlc" # media player
    "whatsapp" # messaging
    "zoom" # video conferencing
  ];
  homebrew.masApps = { # Mac App Store
    "Horo - Timer for Menu Bar" = 1437226581; # timer
    "Logic Pro" = 634148309; # audio editor # large (1GB+)
    "Microsoft Word" = 462054704; # document editor # large (1GB+) # work
  };
  # homebrew.onActivation.cleanup = "uninstall";
  # homebrew.onActivation.cleanup = "zap"; # uninstall and remove all data
  homebrew.onActivation.autoUpdate = true;
  homebrew.onActivation.upgrade = true;

  # Home Manager
  imports = [ <home-manager/nix-darwin> ];

  users.users.gabesaenz = {
    # name = "Gabe Saenz"; # this was causing an error during darwin-rebuild switch
    home = "/Users/gabesaenz";
    shell = pkgs.fish;
  };
  home-manager.users.gabesaenz = { pkgs, ... }: {
    home.stateVersion = "22.05";
    home.packages = with pkgs; [
      # Shell tools
      exa
      bat
      neofetch

      # Spellchecking - used by emacs
      (aspellWithDicts (dicts: with dicts; [
        en # English
        en-computers # English Computer Jargon
        en-science # English Scientific Jargon
        la # Latin
        el # Greek
        grc # Ancient Greek
        de # German
        de-alt # German Old-Spelling
      ]))
      hunspell
      # hunspell dictionaries
      mythes # thesaurus
      hunspellDicts.en_US-large # English (United States) Large
      hunspellDicts.en_GB-large # English (United Kingdom) Large
      hunspellDicts.de_DE # German (Germany)
      enchant

      # Work - Beginning Sanskrit
      pandoc
      libwpd

      # Rust
      cargo
      clippy
      rustc
      rustfmt
      rust-analyzer
      bacon

      # PDF
      djvu2pdf # convert djvu to pdf

      # Media
      # vlc # not supported on ‘x86_64-darwin’

      # Whitenoise
      # sbagen # binaural audio generator # not supported on darwin 2023-01-31
      # blanket # background noise mixer # not supported on darwin 2023-01-31
    ];

    programs.fish = {
      enable = true;
      functions = {
        fish_greeting = {
	        description = "";
	        body = "";
	      };
      };
      shellAliases = {
        ls = "exa -ahl --icons --color-scale --group-directories-first --git";
        cat = "bat";
      };
      # plugins = [
      # { name = "fzf"; src = pkgs.fishPlugins.fzf-fish.src; }
      # ];
    };
    programs.starship.enable = true;
    programs.alacritty.enable = true;
    programs.alacritty.settings = {
      font = {
        normal = {
          family = "NotoSansMono Nerd Font";
        };
        size = 18.0;
      };
      window.decorations = "buttonless";
      shell.program = "fish";
    };

    # launchd.agents = {
    #     name = "emacs-daemon";
    #     command = "/usr/local/opt/emacs-mac/Emacs.app/Contents/MacOS/Emacs --daemon";
    #     serviceConfig.RunAtLoad = true;
    #   };
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
