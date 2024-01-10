{ config, pkgs, ... }:

let
  stylix = builtins.fetchTarball {
    url = "https://github.com/danth/stylix/archive/master.tar.gz";
  };
in {
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
      # terminal
      # rcmd - return : /Applications/Alacritty.app/Contents/MacOS/alacritty
      lcmd - return : kitty --config ~/dotfiles/.config/kitty/kitty.conf --directory=~

      # text editors
      lalt - return : neovide --multigrid --frame none
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
  homebrew.taps = [ "homebrew/services" "railwaycat/emacsmacport" ];
  homebrew.brews = [
    {
      # doom emacs dependency (fixes doom doctor warning)
      name = "dbus";
      restart_service = true;
      start_service = true;
    }
    {
      name = "emacs-mac";
      args = [
        "with-dbus"
        "with-glib"
        "with-imagemagick"
        "with-librsvg"
        "with-native-compilation"
        # "with-no-title-bars" # seems to be causing an error now
        "with-modules" # not sure if this is necessary
      ];
    }
    "npm" # doom emacs dependency
    "mu" # doom emacs dependency
  ];
  homebrew.casks = [
    "adobe-acrobat-reader" # work
    # "alacritty" # terminal emulator
    "basictex" # minimal texlive distribution, provides tlmgr
    "dropbox" # cloud storage
    "firefox" # web browser
    "flux" # nighttime colorshift
    "google-chrome" # web browser
    "kitty" # terminal emulator
    "lapce" # text editor
    "libreoffice" # work
    "iina" # media player
    "neovide" # neovim frontend
    "noisy" # whitenoise generator
    "the-unarchiver" # archive manager
    "simple-comic" # comic book viewer
    "spotify" # music streaming
    "virtualbox" # virtualization
    "vitalsource-bookshelf" # textbook ebook reader
    "vlc" # media player
    "whatsapp" # messaging
    "zoom" # video conferencing
  ];
  homebrew.masApps = { # Mac App Store
    "Horo - Timer for Menu Bar" = 1437226581; # timer
    # "Logic Pro" = 634148309; # audio editor # large (1GB+)
    "Microsoft Word" = 462054704; # document editor # large (1GB+) # work
  };
  # homebrew.onActivation.cleanup = "uninstall"; # disabled as it deleted dependencies
  # homebrew.onActivation.cleanup = "zap"; # uninstall and remove all data # disabled as it deleted dependencies
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
      neofetch

      # Text editing
      kakoune

      # Password management
      pass

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

      # mdbook prereqs
      # mdbook
      # mdbook-pdf
      # chromium (from brew) is also a requirement

      # PDF
      djvu2pdf # convert djvu to pdf

      # Comics
      comical
      mcomix
      termpdfpy
    ];

    fonts.fontconfig.enable = true; # doom emacs dependency

    programs.git = {
      enable = true;
      userEmail = "29664619+gabesaenz@users.noreply.github.com";
      extraConfig = {
        credential.helper = "osxkeychain";
        init.defaultBranch = "main";
      };
      ignores = [ ".DS_Store" ];
    };

    # Theming
    # options: https://danth.github.io/stylix/options/hm.html
    imports = [ (import stylix).homeManagerModules.stylix ];
    stylix = {
      # image = /Users/gabesaenz/dotfiles/nord_lake.png;
      # theme list: https://github.com/tinted-theming/base16-schemes
      base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
      # base16Scheme = "/Users/gabesaenz/dotfiles/nix/themes/nord.yaml";
      fonts = {
        # serif.name = "";
        # sansSerif.name = "";
        monospace = {
          name = "FiraCode Nerd Font Mono";
          package = (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; });
        };
        sizes = {
          applications = 20;
          desktop = 20;
          popups = 20;
          terminal = 20;
        };
      };
      targets.bat.enable = false;
      targets.helix.enable = false;
      # targets.kitty.enable = false;
      # targets.vim.enable = false; # leave this enabled for font settings
    };

    # Shells
    programs.fish = {
      enable = true;
      functions = {
        fish_greeting = {
          description = "";
          body = "";
        };
      };
      shellInit = ''
        # add doom emacs bin to $PATH
        fish_add_path ~/.emacs.d/bin

        # add rust cargo installs to $PATH
        fish_add_path ~/.cargo/bin

        # add tlmgr to $PATH
        # requires brew cask "basictex"
        fish_add_path /usr/local/texlive/2023basic/bin/universal-darwin

        # configure dircolors
        dircolors ~/dotfiles/nord-dir_colors >/dev/null
      '';
      shellAliases = {
        cat = "bat";
        rebuild =
          "nix-channel --update;darwin-rebuild switch && nix store optimise";
        rebuild-quick = "darwin-rebuild switch";
        doomsync = "doom sync && doom upgrade && doom sync && doom doctor";
      };
    };

    # Shell Tools
    programs.oh-my-posh = {
      enable = true;
      useTheme = "nordtron";
    };
    programs.dircolors = { enable = true; };
    programs.bat = {
      enable = true;
      config = { theme = "Nord"; };
    };
    programs.eza = {
      enable = true;
      enableAliases = true;
      git = true;
      icons = true;
      extraOptions = [
        "--all"
        "--group-directories-first"
        "--header"
        "--long"
        "--ignore-glob=.git|.DS_Store"
      ];
    };

    # Terminals
    programs.tmux = {
      enable = true;
      keyMode = "vi";
      mouse = true;
      shell = "/Users/gabesaenz/.nix-profile/bin/fish";
      clock24 = true;
      plugins = with pkgs.tmuxPlugins; [
        nord
        # menus # no nix package
        # digit # no nix package
        mode-indicator
        weather
        # powerline # no nix package
        prefix-highlight
      ];
    };
    # build error
    # programs.alacritty.enable = true;
    # programs.alacritty.settings = {
    #   window.decorations = "buttonless";
    #   shell.program = "fish";
    # };

    # Text Editors
    programs.helix = {
      enable = true;
      defaultEditor = true;
      settings = {
        theme = "nord";
        editor.whitespace.render = "all";
        editor.auto-pairs = false;
      };
    };
    programs.neovim = {
      enable = true;
      defaultEditor = false;
      extraConfig = ''
        " theme
        " placed here to override stylix while still inheriting font settings from stylix
        colorscheme nord

        " hide mouse when typing
        let g:neovide_hide_mouse_when_typing = v:false
      '';
      plugins = with pkgs;
        [
          # nord colorscheme
          {
            plugin = vimPlugins.nord-vim;
            # config = "colorscheme nord";
          }
        ];
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };

    # Email
    programs.offlineimap.enable = true; # doom emacs mu4e dependency
    programs.msmtp.enable = true;
    accounts.email = {
      maildirBasePath = "${config.users.users.gabesaenz.home}/.mail";
      accounts.gmx = {
        primary = true;
        address = "gabriel.saenz@gmx.de";
        userName = "gabriel.saenz@gmx.de";
        passwordCommand = "pass gmx";
        realName = "Gabriel Saenz";
        imap.host = "imap.gmx.net";
        smtp.host = "mail.gmx.net";
        offlineimap.enable = true;
        msmtp.enable = true;
      };
    };
  };
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
