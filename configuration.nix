{
  config,
  pkgs,
  lib,
  modulesPath,
  inputs,
  ...
}:

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
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Environment variables
  environment.variables = {
    XDG_CONFIG_HOME = "$HOME/.config";

    # fix issue with flavours finding its config file
    FLAVOURS_CONFIG_FILE = "$HOME/.config/flavours/config.toml";

    # hide direnv output
    DIRENV_LOG_FORMAT = "";

    # default shell
    SHELL = "nu";

    # default editor
    VISUAL = "$HOME/dotfiles/emacsclient.sh";
    EDITOR = "$HOME/dotfiles/emacsclient.sh";
  };
  # environment.interactiveShellInit = "nu";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  programs.fish.enable = true;
  environment.shells = with pkgs; [
    fish
    nushell
  ];

  # Mac settings

  # Finder
  # Show all file extensions in Finder.
  system.defaults.finder.AppleShowAllExtensions = true;
  # Always show hidden files.
  system.defaults.finder.AppleShowAllFiles = true;

  # Networking
  networking.hostName = "Gabe-Mac"; # Define your hostname.

  # Emacs service
  services.emacs = {
    enable = true;
    package = (
      (pkgs.emacsPackagesFor pkgs.emacs).emacsWithPackages (epkgs: [
        epkgs.vterm
        epkgs.pdf-tools
        epkgs.org-pdftools
        epkgs.saveplace-pdf-view
      ])
    );
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    # doom emacs dependencies
    git
    ripgrep
    coreutils # optional
    fd # optional

    mu # email

    # doom emacs doom doctor suggestions
    cmigemo
    gnugrep # gnu pcre warning
    coreutils-prefixed # gnu ls warning
    editorconfig-core-c # editorconfig
    gnuplot # org-plot/gnuplot dependency
    nixfmt-rfc-style
    pngpaste # org-download-clipboard dependency
    shellcheck
    shfmt
    nodePackages.stylelint
    nodePackages.js-beautify
    nodePackages.npm # npm warning
    cmake # vterm dependency
    nodePackages.prettier # code formatting dependency
    wordnet # for lookup with offline dictionary
    emacsPackages.vterm # bypass vterm compilation
    emacsPackages.pdf-tools # bypass pdf-tools compilation
    poppler # fix pdf-tools compilation error
    libpng # fix pdf-tools compilation error
    imagemagick # fix email mu4e warning
    (aspellWithDicts (
      dicts: with dicts; [
        en # English
        de # German
        la # Latin
        grc # Ancient Greek
      ]
    ))

    # Rust
    rustup
    cargo-binstall # binary installer for rust tools

    # misc
    translate-shell # translator
  ];

  #----=[ Fonts ]=----#
  fonts.packages = with pkgs; [
    # emacs unicode recommendations
    dejavu_fonts
    noto-fonts

    gentium # gentium plus for greek
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji
    # Devanāgarī
    annapurna-sil
    # nerd fonts
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "Iosevka"
        "Noto"
        "VictorMono"
      ];
    })
    # emacs icons
    emacs-all-the-icons-fonts
  ];

  # Window Manager
  services.skhd = {
    enable = true;
    skhdConfig = ''
      ## Navigation (lalt - ...)
      # Space Navigation (four spaces per display): lalt - {1, 2, 3, 4}
      lalt - 1 : SPACES=($(yabai -m query --displays --display | jq '.spaces[]')) && [[ -n $SPACES[1] ]] && yabai -m space --focus $SPACES[1]
      lalt - 2 : SPACES=($(yabai -m query --displays --display | jq '.spaces[]')) && [[ -n $SPACES[2] ]] && yabai -m space --focus $SPACES[2]
      lalt - 3 : SPACES=($(yabai -m query --displays --display | jq '.spaces[]')) && [[ -n $SPACES[3] ]] && yabai -m space --focus $SPACES[3]
      lalt - 4 : SPACES=($(yabai -m query --displays --display | jq '.spaces[]')) && [[ -n $SPACES[4] ]] && yabai -m space --focus $SPACES[4]

      # Window Navigation (through display borders): lalt - {h, j, k, l}
      lalt - h : yabai -m window --focus west  || yabai -m display --focus west
      lalt - j : yabai -m window --focus south || yabai -m display --focus south
      lalt - k : yabai -m window --focus north || yabai -m display --focus north
      lalt - l : yabai -m window --focus east  || yabai -m display --focus east

      # Extended Window Navigation: lalt - {semicolon, single-quote}
      lalt - 0x29 : yabai -m window --focus first
      lalt - 0x27 : yabai -m window --focus  last

      # Float / Unfloat window: lalt - space
      lalt - space : yabai -m window --toggle float

      # Make window fullscreen: fn - f
      fn - f : yabai -m window --toggle native-fullscreen

      # Make window zoom to parent node: lalt - f
      lalt - f : yabai -m window --toggle zoom-parent

      ## Window Movement (shift + lalt - ...)
      # Moving windows in spaces: shift + lalt - {h, j, k, l}
      shift + lalt - h : yabai -m window --warp west || $(yabai -m window --display west && yabai -m display --focus west && yabai -m window --warp last) || yabai -m window --move rel:-10:0
      shift + lalt - j : yabai -m window --warp south || $(yabai -m window --display south && yabai -m display --focus south) || yabai -m window --move rel:0:10
      shift + lalt - k : yabai -m window --warp north || $(yabai -m window --display north && yabai -m display --focus north) || yabai -m window --move rel:0:-10
      shift + lalt - l : yabai -m window --warp east || $(yabai -m window --display east && yabai -m display --focus east && yabai -m window --warp first) || yabai -m window --move rel:10:0

      # Toggle split orientation of the selected windows node: shift + lalt - s
      shift + lalt - s : yabai -m window --toggle split

      # Moving windows between spaces: shift + lalt - {1, 2, 3, 4, n , p} (Assumes 4 Spaces Max per Display)
      shift + lalt - 1 : SPACES=($(yabai -m query --displays --display | jq '.spaces[]')) && [[ -n $SPACES[1] ]] \
                        && yabai -m window --space $SPACES[1]

      shift + lalt - 2 : SPACES=($(yabai -m query --displays --display | jq '.spaces[]')) && [[ -n $SPACES[2] ]] \
                        && yabai -m window --space $SPACES[2]

      shift + lalt - 3 : SPACES=($(yabai -m query --displays --display | jq '.spaces[]')) && [[ -n $SPACES[3] ]] \
                        && yabai -m window --space $SPACES[3]

      shift + lalt - 4 : SPACES=($(yabai -m query --displays --display | jq '.spaces[]')) && [[ -n $SPACES[4] ]] \
                        && yabai -m window --space $SPACES[4]

      shift + lalt - n : yabai -m window --space next && yabai -m space --focus next
      shift + lalt - p : yabai -m window --space prev && yabai -m space --focus prev

      # Mirror Space on X and Y Axis: shift + lalt - {x, y}
      shift + lalt - x : yabai -m space --mirror x-axis
      shift + lalt - y : yabai -m space --mirror y-axis

      ## Stacks (shift + ctrl - ...)
      # Add the active window to the window or stack to the {direction}: shift + ctrl - {h, j, k, l}
      shift + ctrl - h : yabai -m window  west --stack $(yabai -m query --windows --window | jq -r '.id')
      shift + ctrl - j : yabai -m window south --stack $(yabai -m query --windows --window | jq -r '.id')
      shift + ctrl - k : yabai -m window north --stack $(yabai -m query --windows --window | jq -r '.id')
      shift + ctrl - l : yabai -m window  east --stack $(yabai -m query --windows --window | jq -r '.id')

      # Stack Navigation: shift + ctrl - {n, p}
      shift + ctrl - n : yabai -m window --focus stack.next
      shift + ctrl - p : yabai -m window --focus stack.prev

      ## Resize (ctrl + lalt - ...)
      # Resize windows: ctrl + lalt - {h, j, k, l}
      ctrl + lalt - h : yabai -m window --resize right:-100:0 || yabai -m window --resize left:-100:0
      ctrl + lalt - j : yabai -m window --resize bottom:0:100 || yabai -m window --resize top:0:100
      ctrl + lalt - k : yabai -m window --resize bottom:0:-100 || yabai -m window --resize top:0:-100
      ctrl + lalt - l : yabai -m window --resize right:100:0 || yabai -m window --resize left:100:0

      # Equalize size of windows: ctrl + lalt - e
      ctrl + lalt - e : yabai -m space --balance

      # Enable / Disable gaps in current workspace: ctrl + lalt - g
      ctrl + lalt - g : yabai -m space --toggle padding; yabai -m space --toggle gap

      # Enable / Disable window borders in current workspace: (shift +) ctrl + lalt - b
      ctrl + lalt - b : yabai -m config window_border off
      shift + ctrl + lalt - b : yabai -m config window_border on

      ## Insertion (shift + ctrl + lalt - ...)
      # Set insertion point for focused container: shift + ctrl + lalt - {h, j, k, l, s}
      shift + ctrl + lalt - h : yabai -m window --insert west
      shift + ctrl + lalt - j : yabai -m window --insert south
      shift + ctrl + lalt - k : yabai -m window --insert north
      shift + ctrl + lalt - l : yabai -m window --insert east
      shift + ctrl + lalt - s : yabai -m window --insert stack

      # New window in hor./ vert. splits for all applications with yabai
      lalt - s : yabai -m window --insert east;  skhd -k "cmd - n"
      lalt - v : yabai -m window --insert south; skhd -k "cmd - n"

      ########################
      # application shortcuts:
      ########################

      # terminal
      rcmd - return : /Applications/Alacritty.app/Contents/MacOS/alacritty

      # text editors
      ralt - return : $HOME/dotfiles/emacsclient.sh
      # backslash: 0x2A
      ralt - 0x2A : neovide

      # web browser
      # right square bracket: 0x1E
      rcmd - 0x1E : /Applications/Firefox.app/Contents/MacOS/firefox

      # pdf viewer
      # backslash: 0x2A
      rcmd - 0x2A : zathura

      ##########
      # theming:
      ##########

      # color schemes
      # slash: 0x2C
      fn - 0x2C : flavours apply
      # comma: 0x2B
      fn - 0x2B : $HOME/dotfiles/.config/flavours/previous-theme.sh
      # period: 0x2F
      fn - 0x2F : $HOME/dotfiles/.config/flavours/next-theme.sh

      # desktop wallpapers
      # backslash: 0x2A
      fn - 0x2A : $HOME/dotfiles/background-images/reload-wallpaper.sh
      # left square bracket: 0x21
      fn - 0x21 : $HOME/dotfiles/background-images/previous-wallpaper.sh
      # right square bracket: 0x1E
      fn - 0x1E : $HOME/dotfiles/background-images/next-wallpaper.sh
    '';
  };
  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    enableScriptingAddition = true;
    extraConfig = ''
      #!/usr/bin/env sh

      sudo yabai --load-sa
      yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"

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

      # emacsclient fixes
      # manage emacsclient windows
      yabai -m rule --add app="^emacs$" role="^AXTextField$" subrole="^AXStandardWindow$" manage=on
      # focus newly created emacsclient windows
      yabai -m signal --add event=window_created app="^emacs$" action="yabai -m window --focus \$YABAI_WINDOW_ID"
      # focus recent or first window on closing an emacs window
      # focus recent seems like the intended behavior but only focus first seems to be working in this situation
      yabai -m signal --add event=window_destroyed app="^emacs$" action="yabai -m window --focus recent || yabai -m window --focus first"

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
    "homebrew/services"
    "codecrafters-io/tap" # codecrafters cli for programming exercises
  ];
  homebrew.brews = [
    "gcc" # doom emacs dependency (native compilation)
    "libvterm" # doom emacs dependency (vterm)

    "codecrafters" # programming exercises
    "exercism" # programming exercises
    "flavours" # theming
    "gowall" # wallpaper theming
    "svg2png" # convert SVG to PNG
    "vimtutor-sequel"
  ];
  homebrew.casks = [
    "adobe-acrobat-reader" # work
    "adobe-digital-editions" # DRM PDF reader
    "alacritty" # terminal emulator
    "anki" # flashcards
    "basictex" # minimal texlive distribution, provides tlmgr
    "calibre" # ebook library
    "dropbox" # cloud storage
    "firefox" # web browser
    "flux" # nighttime colorshift
    "google-chrome" # web browser
    "inkscape" # svg editor
    "keycastr" # display keys pressed
    "kitty" # terminal emulator
    "languagetool" # grammar checker
    "libreoffice" # work
    "neovide" # nvim frontend
    "simple-comic" # comic book viewer
    "spotify" # music streaming
    "the-unarchiver" # archive manager
    "virtualbox" # virtualization
    "vlc" # media player
    "warp" # terminal emulator
    "whatsapp" # messaging
    "yacreader" # comic book library
    "zoom" # video conferencing
  ];
  # homebrew.masApps = {
  #   # Mac App Store
  #   "Horo - Timer for Menu Bar" = 1437226581; # timer
  #   "Logic Pro" = 634148309; # audio editor # large (1GB+)
  #   "Microsoft Word" = 462054704; # document editor # large (1GB+) # work
  # };
  # uninstall and remove all data from anything not listed above
  homebrew.onActivation.cleanup = "zap";
  # prevent auto update
  homebrew.global.autoUpdate = false;
  homebrew.onActivation.autoUpdate = false;
  homebrew.onActivation.upgrade = false;

  # allow unfree packages
  nixpkgs.config.allowUnfree = true;

  users.users.gabesaenz = {
    home = "/Users/gabesaenz";
    shell = pkgs.nushell;
    ignoreShellProgramCheck = true;
  };
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
