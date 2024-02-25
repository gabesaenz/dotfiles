{ config, pkgs, lib, modulesPath, inputs, ... }:

{
  # home.username = "gabesaenz";
  # home.homeDirectory = "/Users/gabesaenz";
  home.stateVersion = "22.05";
  home.packages = with pkgs; [
    # Shell tools
    neofetch
    pv

    # Text editors
    micro

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

    # PDF
    djvu2pdf # convert djvu to pdf
    sioyek
    zathura

    # Spotify
    spicetify-cli
    spotify-tui
  ];

  home.file.sketchybar = {
    source = ./dotfiles/.config/sketchybar;
    target = "./.config/sketchybar";
  };

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

  # Shells
  programs.zsh = {
    enable = true;
    oh-my-zsh = { enable = true; };
  };
  programs.fish = {
    enable = true;
    functions = {
      fish_greeting = {
        description = "";
        body = "";
      };
      # sketchybar brew updates checker
      brew = {
        description = "";
        body = ''
          command brew "$@"

          if [[ $* =~ "upgrade" ]] || [[ $* =~ "update" ]] || [[ $* =~ "outdated" ]]; then
            sketchybar --trigger brew_update
          fi
        '';
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

      # direnv integration
      direnv hook fish | source
    '';
    shellAliases = {
      cat = "bat";
      top = "btop";
      rebuild = "rebuild-nix && rebuild-brew && garbage && doomsync";
      rebuild-nix =
        "nix flake update ~/dotfiles/ && darwin-rebuild switch --flake ~/dotfiles/ && nix store optimise";
      rebuild-brew =
        "brew update && brew upgrade && brew autoremove && brew cleanup";
      rebuild-quick = "darwin-rebuild switch --flake ~/dotfiles/";
      doomsync = "doom sync && doom upgrade && doom sync && doom doctor";
      garbage = "sudo nix-collect-garbage -d && nix-collect-garbage -d";
    };
  };

  # Shell Tools
  programs.btop = { enable = true; };
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
  programs.dircolors = { enable = true; };
  programs.bat = {
    enable = true;
    config = { theme = "Nord"; };
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.lazygit = { enable = true; };
  programs.oh-my-posh = {
    enable = true;
    useTheme = "nordtron";
  };

  # Terminals
  programs.kitty = {
    enable = true;
    darwinLaunchOptions = [
      # "--single-instance"
      "--directory=~"
    ];
    extraConfig = ''
      # default shell
      shell fish

      # disable confirm on close
      confirm_os_window_close 0

      # fonts
      font_family FiraCode Nerd Font Mono
      font_size 20.0

      # Devanāgarī support
      # from : https://www.wikiwand.com/en/Devanagari#Unicode
      # The Unicode Standard defines four blocks for Devanāgarī: Devanagari (U+0900–U+097F), Devanagari Extended (U+A8E0–U+A8FF), Devanagari Extended-A (U+11B00–11B5F), and Vedic Extensions (U+1CD0–U+1CFF).
      # symbol_map U+0900–U+097F,U+A8E0–U+A8FF,U+11B00–11B5F,U+1CD0–U+1CFF Annapurna SIL

      # window decorations
      hide_window_decorations titlebar-only

      # transparency
      background_opacity 0.7

      # blur
      background_blur 32

      # startup session
      startup_session ~/dotfiles/.config/kitty/kitty-startup.session
    '';
    theme = "Nord";
  };
  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    mouse = true;
    sensibleOnTop = false;
    shell = "/Users/gabesaenz/.nix-profile/bin/fish";
    terminal = "tmux-direct";
    plugins = with pkgs.tmuxPlugins; [ nord ];
    extraConfig = ''
      set-option -g status off
      bind-key b set-option status
    '';
  };

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
      colorscheme nord

      " hide mouse when typing
      let g:neovide_hide_mouse_when_typing = v:false

      " transparency
      let g:neovide_transparency = 0.7

      " blur
      let g:neovide_window_blurred = v:true
    '';
    plugins = with pkgs; [{
      plugin = vimPlugins.nord-vim; # nord colorscheme
    }];
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  # Email
  programs.offlineimap.enable = true; # doom emacs mu4e dependency
  programs.msmtp.enable = true;
  accounts.email = {
    maildirBasePath = "/Users/gabesaenz/.mail";
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

  # Spotify
  # not supported on MacOS/nix-darwin
  # services.spotifyd = {
  #   enable = true;
  #   settings = {
  #     global = {
  #       username = "gabesaenz@gmail.com";
  #       password_cmd = "pass spotify";
  #       # device_name = "macground";
  #     };
  #   };
  # };
}
