{ config, pkgs, lib, modulesPath, inputs, ... }:

{
  # Nix settings

  # Channels
  # darwin https://github.com/LnL7/nix-darwin/archive/master.tar.gz
  # home-manager https://github.com/nix-community/home-manager/archive/master.tar.gz
  # nixpkgs https://nixos.org/channels/nixpkgs-unstable
  # Update them with: nix-channel --update
  # Also update the root channels with: sudo -i nix-channel --update

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
    XDG_CONFIG_HOME = "$HOME/.config";

    # fix issue with flavours finding its config file
    FLAVOURS_CONFIG_FILE = "$HOME/.config/flavours/config.toml";

    # doom emacs config folder
    DOOMDIR = "$HOME/dotfiles/.config/.doom.d";

    # remove Neovide titlebar
    # NEOVIDE_FRAME = "none";

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
    # sketchybar font
    sketchybar-app-font
  ];

  # Window Manager
  services.skhd = {
    enable = true;
    # old personal config
    # skhdConfig = ''
    #   # Reload config
    #   fn - r: skhd --reload

    #   #################
    #   # yabai controls:
    #   #################

    #   # focus window
    #   meh - h : yabai -m window --focus west
    #   meh - j : yabai -m window --focus south
    #   meh - k : yabai -m window --focus north
    #   meh - l : yabai -m window --focus east

    #   # swap managed window
    #   hyper - h : yabai -m window --swap west
    #   hyper - j : yabai -m window --swap south
    #   hyper - k : yabai -m window --swap north
    #   hyper - l : yabai -m window --swap east

    #   # send window to desktop
    #   hyper - 1 : yabai -m window --space 1
    #   hyper - 2 : yabai -m window --space 2
    #   hyper - 3 : yabai -m window --space 3
    #   hyper - 4 : yabai -m window --space 4
    #   hyper - 5 : yabai -m window --space 5
    #   hyper - 6 : yabai -m window --space 6
    #   hyper - 7 : yabai -m window --space 7
    #   hyper - 8 : yabai -m window --space 8
    #   hyper - 9 : yabai -m window --space 9

    #   # move floating window
    #   meh - y : yabai -m window --move rel:-20:0
    #   meh - u : yabai -m window --move rel:0:20
    #   meh - i : yabai -m window --move rel:0:-20
    #   meh - o : yabai -m window --move rel:20:0

    #   # increase window size
    #   hyper - y : yabai -m window --resize left:-20:0
    #   hyper - i : yabai -m window --resize top:0:-20

    #   # decrease window size
    #   hyper - o : yabai -m window --resize left:20:0
    #   hyper - u : yabai -m window --resize top:0:20

    #   # balance size of windows
    #   hyper - 0 : yabai -m space --balance

    #   # toggle window zoom
    #   fn - y : yabai -m window --toggle zoom-parent
    #   fn - u : yabai -m window --toggle zoom-fullscreen

    #   # toggle window split type
    #   fn - i : yabai -m window --toggle split

    #   # float / unfloat window and center on screen
    #   fn - o : yabai -m window --toggle float --grid 4:4:1:1:2:2

    #   # toggle sticky(+float), picture-in-picture
    #   fn - p : yabai -m window --toggle sticky --toggle pip

    #   ########################
    #   # application shortcuts:
    #   ########################

    #   # terminal
    #   rcmd - return : /Applications/kitty.app/Contents/MacOS/kitty

    #   # text editors
    #   ralt - return : emacsclient -c -a "emacs"
    #   meh - return : /Applications/Neovide.app/Contents/MacOS/neovide
    #   hyper - return : /Applications/Neovide.app/Contents/MacOS/neovide --frame none
    # '';
    skhdConfig = ''
      ## Navigation (lalt - ...)
      # Space Navigation (four spaces per display): lalt - {1, 2, 3, 4}
      lalt - 1 : SPACES=($(yabai -m query --displays --display | jq '.spaces[]')) && [[ -n $SPACES[1] ]] && yabai -m space --focus $SPACES[1]
      lalt - 2 : SPACES=($(yabai -m query --displays --display | jq '.spaces[]')) && [[ -n $SPACES[2] ]] && yabai -m space --focus $SPACES[2]
      lalt - 3 : SPACES=($(yabai -m query --displays --display | jq '.spaces[]')) && [[ -n $SPACES[3] ]] && yabai -m space --focus $SPACES[3]
      lalt - 4 : SPACES=($(yabai -m query --displays --display | jq '.spaces[]')) && [[ -n $SPACES[4] ]] && yabai -m space --focus $SPACES[4]

      # Window Navigation (through display borders): lalt - {j, k, l, ö}
      lalt - j    : yabai -m window --focus west  || yabai -m display --focus west
      lalt - k    : yabai -m window --focus south || yabai -m display --focus south
      lalt - l    : yabai -m window --focus north || yabai -m display --focus north
      lalt - 0x29 : yabai -m window --focus east  || yabai -m display --focus east

      # Extended Window Navigation: lalt - {h, ä}
      lalt -    h : yabai -m window --focus first
      lalt - 0x27 : yabai -m window --focus  last

      # Float / Unfloat window: lalt - space
      lalt - space : yabai -m window --toggle float; sketchybar --trigger window_focus

      # Make window zoom to fullscreen: shift + lalt - f
      shift + lalt - f : yabai -m window --toggle zoom-fullscreen; sketchybar --trigger window_focus

      # Make window zoom to parent node: lalt - f
      lalt - f : yabai -m window --toggle zoom-parent; sketchybar --trigger window_focus

      ## Window Movement (shift + lalt - ...)
      # Moving windows in spaces: shift + lalt - {j, k, l, ö}
      shift + lalt - j : yabai -m window --warp west || $(yabai -m window --display west && yabai -m display --focus west && yabai -m window --warp last) || yabai -m window --move rel:-10:0
      shift + lalt - k : yabai -m window --warp south || $(yabai -m window --display south && yabai -m display --focus south) || yabai -m window --move rel:0:10
      shift + lalt - l : yabai -m window --warp north || $(yabai -m window --display north && yabai -m display --focus north) || yabai -m window --move rel:0:-10
      shift + lalt - 0x29 : yabai -m window --warp east || $(yabai -m window --display east && yabai -m display --focus east && yabai -m window --warp first) || yabai -m window --move rel:10:0

      # Toggle split orientation of the selected windows node: shift + lalt - s
      shift + lalt - s : yabai -m window --toggle split

      # Moving windows between spaces: shift + lalt - {1, 2, 3, 4, p, n } (Assumes 4 Spaces Max per Display)
      shift + lalt - 1 : SPACES=($(yabai -m query --displays --display | jq '.spaces[]')) && [[ -n $SPACES[1] ]] \
                        && yabai -m window --space $SPACES[1] && sketchybar --trigger windows_on_spaces

      shift + lalt - 2 : SPACES=($(yabai -m query --displays --display | jq '.spaces[]')) && [[ -n $SPACES[2] ]] \
                        && yabai -m window --space $SPACES[2] && sketchybar --trigger windows_on_spaces

      shift + lalt - 3 : SPACES=($(yabai -m query --displays --display | jq '.spaces[]')) && [[ -n $SPACES[3] ]] \
                        && yabai -m window --space $SPACES[3] && sketchybar --trigger windows_on_spaces

      shift + lalt - 4 : SPACES=($(yabai -m query --displays --display | jq '.spaces[]')) && [[ -n $SPACES[4] ]] \
                        && yabai -m window --space $SPACES[4] && sketchybar --trigger windows_on_spaces

      shift + lalt - p : yabai -m window --space prev && yabai -m space --focus prev
      shift + lalt - n : yabai -m window --space next && yabai -m space --focus next

      # Mirror Space on X and Y Axis: shift + lalt - {x, y}
      shift + lalt - x : yabai -m space --mirror x-axis
      shift + lalt - y : yabai -m space --mirror y-axis

      ## Stacks (shift + ctrl - ...)
      # Add the active window to the window or stack to the {direction}: shift + ctrl - {j, k, l, ö}
      shift + ctrl - j    : yabai -m window  west --stack $(yabai -m query --windows --window | jq -r '.id') && sketchybar --trigger window_focus
      shift + ctrl - k    : yabai -m window south --stack $(yabai -m query --windows --window | jq -r '.id') && sketchybar --trigger window_focus
      shift + ctrl - l    : yabai -m window north --stack $(yabai -m query --windows --window | jq -r '.id') && sketchybar --trigger window_focus
      shift + ctrl - 0x29 : yabai -m window  east --stack $(yabai -m query --windows --window | jq -r '.id') && sketchybar --trigger window_focus

      # Stack Navigation: shift + ctrl - {n, p}
      shift + ctrl - n : yabai -m window --focus stack.next
      shift + ctrl - p : yabai -m window --focus stack.prev

      ## Resize (ctrl + lalt - ...)
      # Resize windows: ctrl + lalt - {j, k, l, ö}
      ctrl + lalt - j    : yabai -m window --resize right:-100:0 || yabai -m window --resize left:-100:0
      ctrl + lalt - k    : yabai -m window --resize bottom:0:100 || yabai -m window --resize top:0:100
      ctrl + lalt - l    : yabai -m window --resize bottom:0:-100 || yabai -m window --resize top:0:-100
      ctrl + lalt - 0x29 : yabai -m window --resize right:100:0 || yabai -m window --resize left:100:0

      # Equalize size of windows: ctrl + lalt - e
      ctrl + lalt - e : yabai -m space --balance

      # Enable / Disable gaps in current workspace: ctrl + lalt - g
      ctrl + lalt - g : yabai -m space --toggle padding; yabai -m space --toggle gap

      # Enable / Disable gaps in current workspace: ctrl + lalt - g
      ctrl + lalt - b : yabai -m config window_border off
      shift + ctrl + lalt - b : yabai -m config window_border on

      ## Insertion (shift + ctrl + lalt - ...)
      # Set insertion point for focused container: shift + ctrl + lalt - {j, k, l, ö, s}
      shift + ctrl + lalt - j : yabai -m window --insert west
      shift + ctrl + lalt - k : yabai -m window --insert south
      shift + ctrl + lalt - l : yabai -m window --insert north
      shift + ctrl + lalt - 0x29 : yabai -m window --insert east
      shift + ctrl + lalt - s : yabai -m window --insert stack

      ## Misc
      # Open new Alacritty window
      lalt - t : alacritty msg create-window

      # New window in hor./ vert. splits for all applications with yabai
      lalt - s : yabai -m window --insert east;  skhd -k "cmd - n"
      lalt - v : yabai -m window --insert south; skhd -k "cmd - n"

      # Toggle sketchybar
      shift + lalt - space : sketchybar --bar hidden=toggle
      shift + lalt - r : sketchybar --remove '/.*/' && sh -c 'export CONFIG_DIR=$HOME/.config/sketchybar && $CONFIG_DIR/sketchybarrc'

      ########################
      # application shortcuts:
      ########################

      # terminal
      rcmd - return : /Applications/kitty.app/Contents/MacOS/kitty

      # text editors
      ralt - return : emacsclient -c -a "emacs"
      meh - return : /Applications/Neovide.app/Contents/MacOS/neovide

      ##########
      # theming:
      ##########

      # slash
      fn - 0x2C : flavours apply
      # comma
      fn - 0x2B : $HOME/dotfiles/.config/flavours/previous-theme.sh
      # period
      fn - 0x2F : $HOME/dotfiles/.config/flavours/next-theme.sh
    '';
  };
  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    enableScriptingAddition = true;
    # config = {
    #   focus_follows_mouse = "off";
    #   mouse_follows_focus = "off";
    #   window_placement = "second_child";
    #   window_opacity = "off";
    #   window_opacity_duration = "0.0";
    #   window_animation_duration = "0.0";
    #   window_border = "off";
    #   active_window_border_topmost = "off";
    #   window_topmost = "on";
    #   active_window_opacity = "1.0";
    #   normal_window_opacity = "1.0";
    #   split_ratio = "0.50";
    #   auto_balance = "on";
    #   layout = "bsp";
    # };
    extraConfig = ''
      #!/usr/bin/env sh

      sudo yabai --load-sa
      yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"
      yabai -m signal --add event=window_focused action="sketchybar --trigger window_focus"
      yabai -m signal --add event=window_created action="sketchybar --trigger windows_on_spaces"
      yabai -m signal --add event=window_destroyed action="sketchybar --trigger windows_on_spaces"

      yabai -m config external_bar               all:0:0      \
                      mouse_follows_focus        off          \
                      focus_follows_mouse        off          \
                      window_zoom_persist        off          \
                      window_placement           second_child \
                      window_topmost             off          \
                      window_shadow              float        \
                      window_opacity             on           \
                      window_opacity_duration    0.2          \
                      active_window_opacity      1.0          \
                      normal_window_opacity      0.9          \
                      window_animation_duration  0.3          \
                      insert_feedback_color      0xff9dd274   \
                      split_ratio                0.50         \
                      auto_balance               off          \
                      auto_padding               on           \
                      mouse_modifier             fn           \
                      mouse_action1              move         \
                      mouse_action2              resize       \
                      mouse_drop_action          swap         \
                                                              \
                      top_padding                5            \
                      bottom_padding             5            \
                      left_padding               5            \
                      right_padding              5            \
                      window_gap                 5
      # Exclude problematic apps from being managed:
      yabai -m rule --add app="^(LuLu|Calculator|Software Update|Dictionary|VLC|System Preferences|System Settings|zoom.us|Photo Booth|Archive Utility|Python|LibreOffice|App Store|Steam|Alfred|Activity Monitor)$" manage=off
      yabai -m rule --add label="Finder" app="^Finder$" title="(Co(py|nnect)|Move|Info|Pref)" manage=off
      yabai -m rule --add label="Safari" app="^Safari$" title="^(General|(Tab|Password|Website|Extension)s|AutoFill|Se(arch|curity)|Privacy|Advance)$" manage=off
      yabai -m rule --add label="About This Mac" app="System Information" title="About This Mac" manage=off
      yabai -m rule --add label="Select file to save to" app="^Inkscape$" title="Select file to save to" manage=off

      yabai -m config layout bsp

      echo "yabai configuration loaded.."
    '';
  };

  homebrew.enable = true;
  homebrew.taps = [
    # "homebrew/cask"
    "homebrew/services"
    "homebrew/cask-fonts" # used for nerd fonts
    "d12frosted/emacs-plus" # emacs
    "FelixKratz/formulae" # sketchybar
  ];
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
    {
      name = "sketchybar";
      # restart_service = true;
      # start_service = true;
    }
    "npm" # doom emacs dependency
    "mu" # doom emacs dependency
    "gcc" # doom emacs dependency (native compilation)
    "libvterm" # doom emacs dependency (vterm)
    "gh" # github-cli # used by sketchybar
    "jq" # used by sketchybar
    "switchaudio-osx" # cli audio source switcher # used by sketchybar
    "flavours" # theming
    "svg2png" # convert SVG to PNG
  ];
  homebrew.casks = [
    #fonts
    "font-hack-nerd-font" # used by sketchybar
    "sf-symbols" # used by sketchybar
    "font-sf-mono" # used by nvim config from sketchybar creator

    "adobe-acrobat-reader" # work
    "basictex" # minimal texlive distribution, provides tlmgr
    "dropbox" # cloud storage
    "element" # matrix chat client
    "ferdium" # chat service
    "firefox" # web browser
    "flux" # nighttime colorshift
    "google-chrome" # web browser
    "inkscape" # svg editor
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
