{ config, pkgs, lib, modulesPath, inputs, ... }:

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
  # this causes issues during rebuilds on mac so it's disabled for now
  # run it manually with: nix-store --optimise
  # nix.settings.auto-optimise-store = true;

  # Garbage collection
  # https://nixos.wiki/wiki/Storage_optimization#Automation
  # Also run these commands to manually clean up garbage:
  # nix-collect-garbage -d
  # sudo nix-collect-garbage -d
  nix.gc = {
    automatic = true;
    interval = {
      Weekday = 0;
      Hour = 0;
      Minute = 0;
    };
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

  # Environment variables
  environment.variables = {
    # doom emacs config folder
    DOOMDIR = "$HOME/dotfiles/.config/.doom.d";

    # remove Neovide titlebar
    NEOVIDE_FRAME = "none";

    # hide direnv output
    DIRENV_LOG_FORMAT = "";
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  programs.fish.enable = true;
  environment.shells = with pkgs; [ fish ];
  environment.loginShell = "/run/current-system/sw/bin/fish";

  # Mac settings

  # Finder
  # Show all file extensions in Finder.
  system.defaults.finder.AppleShowAllExtensions = true;
  # Always show hidden files.
  system.defaults.finder.AppleShowAllFiles = true;

  # Networking
  networking.hostName = "Gabe-Mac"; # Define your hostname.

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    # doom emacs dependencies
    git
    ripgrep
    coreutils # optional
    fd # optional
    # doom emacs doom doctor suggestions
    cmigemo
    gnugrep # gnu pcre warning
    coreutils-prefixed # gnu ls warning
    nixfmt
    shellcheck
    shfmt
    nodePackages.stylelint
    nodePackages.js-beautify
    cmake # vterm dependency
  ];

  # Fonts
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    # Devanāgarī
    annapurna-sil
    # nerd fonts
    (nerdfonts.override { fonts = [ "Noto" "FiraCode" ]; })
    # emacs icons
    emacs-all-the-icons-fonts
  ];

  # Window Manager
  services.skhd = {
    enable = true;
    skhdConfig = ''
      # Reload config
      fn - r: skhd --reload

      #################
      # yabai controls:
      #################

      # focus window
      meh - h : yabai -m window --focus west
      meh - j : yabai -m window --focus south
      meh - k : yabai -m window --focus north
      meh - l : yabai -m window --focus east

      # swap managed window
      hyper - h : yabai -m window --swap west
      hyper - j : yabai -m window --swap south
      hyper - k : yabai -m window --swap north
      hyper - l : yabai -m window --swap east

      # send window to desktop
      hyper - 1 : yabai -m window --space 1
      hyper - 2 : yabai -m window --space 2
      hyper - 3 : yabai -m window --space 3
      hyper - 4 : yabai -m window --space 4
      hyper - 5 : yabai -m window --space 5
      hyper - 6 : yabai -m window --space 6
      hyper - 7 : yabai -m window --space 7
      hyper - 8 : yabai -m window --space 8
      hyper - 9 : yabai -m window --space 9

      # move floating window
      meh - y : yabai -m window --move rel:-20:0
      meh - u : yabai -m window --move rel:0:20
      meh - i : yabai -m window --move rel:0:-20
      meh - o : yabai -m window --move rel:20:0

      # increase window size
      hyper - y : yabai -m window --resize left:-20:0
      hyper - i : yabai -m window --resize top:0:-20

      # decrease window size
      hyper - o : yabai -m window --resize left:20:0
      hyper - u : yabai -m window --resize top:0:20

      # balance size of windows
      hyper - 0 : yabai -m space --balance

      # toggle window zoom
      fn - y : yabai -m window --toggle zoom-parent
      fn - u : yabai -m window --toggle zoom-fullscreen

      # toggle window split type
      fn - i : yabai -m window --toggle split

      # float / unfloat window and center on screen
      fn - o : yabai -m window --toggle float --grid 4:4:1:1:2:2

      # toggle sticky(+float), picture-in-picture
      fn - p : yabai -m window --toggle sticky --toggle pip


      ########################
      # application shortcuts:
      ########################

      # terminal
      rcmd - return : /Applications/kitty.app/Contents/MacOS/kitty

      # text editors
      ralt - return : emacsclient -c -a "emacs"
      meh - return : /Applications/Neovide.app/Contents/MacOS/neovide
      hyper - return : /Applications/Neovide.app/Contents/MacOS/neovide --frame none
    '';
  };
  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    enableScriptingAddition = true;
    config = {
      focus_follows_mouse = "off";
      mouse_follows_focus = "off";
      window_placement = "second_child";
      window_opacity = "off";
      window_opacity_duration = "0.0";
      window_animation_duration = "0.0";
      window_border = "off";
      active_window_border_topmost = "off";
      window_topmost = "on";
      active_window_opacity = "1.0";
      normal_window_opacity = "1.0";
      split_ratio = "0.50";
      auto_balance = "on";
      layout = "bsp";
    };
    extraConfig = ''
      # rules
      yabai -m rule --add app='System Preferences' manage=off
    '';
  };

  homebrew.enable = true;
  homebrew.taps = [ "homebrew/services" "d12frosted/emacs-plus" ];
  homebrew.brews = [
    {
      # doom emacs dependency (fixes doom doctor warning)
      name = "dbus";
      restart_service = true;
      start_service = true;
    }
    {
      name = "emacs-plus";
      args = [
        "with-dbus"
        "with-mailutils"
        "with-no-frame-refocus"
        "with-imagemagick"
        "with-native-comp"
      ];
      # restart_service = true;
      start_service = true;
    }
    "npm" # doom emacs dependency
    "mu" # doom emacs dependency
    "gcc" # doom emacs dependency (native compilation)
    "libvterm" # doom emacs dependency (vterm)
  ];
  homebrew.casks = [
    "adobe-acrobat-reader" # work
    "basictex" # minimal texlive distribution, provides tlmgr
    "dropbox" # cloud storage
    "firefox" # web browser
    "flux" # nighttime colorshift
    "google-chrome" # web browser
    "kitty" # terminal emulator
    "libreoffice" # work
    "neovide" # neovim frontend
    "simple-comic" # comic book viewer
    "spotify" # music streaming
    "the-unarchiver" # archive manager
    "virtualbox" # virtualization
    "vlc" # media player
    "whatsapp" # messaging
    "yacreader" # comic book library
    "zoom" # video conferencing
  ];
  homebrew.masApps = { # Mac App Store
    "Horo - Timer for Menu Bar" = 1437226581; # timer
    "Logic Pro" = 634148309; # audio editor # large (1GB+)
    "Microsoft Word" = 462054704; # document editor # large (1GB+) # work
  };
  homebrew.onActivation.cleanup =
    "zap"; # uninstall and remove all data from anything not listed above
  homebrew.onActivation.autoUpdate = true;
  homebrew.onActivation.upgrade = true;

  users.users.gabesaenz = {
    home = "/Users/gabesaenz";
    shell = pkgs.fish;
  };
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
