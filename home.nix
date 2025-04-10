{
  config,
  pkgs,
  lib,
  modulesPath,
  inputs,
  ...
}:

{
  home.stateVersion = "22.05";
  home.packages = with pkgs; [
    # Shell tools
    neofetch # display OS information
    pv # progress indicator for shell commands
    skhd # standalone install for use with "skhd --observe"
    dwt1-shell-color-scripts # colorscripts for shell greeting
    tmatrix # The Matrix style animation
    hyperfine # Command-line benchmarking tool
    ripgrep-all # Ripgrep, but also search in PDFs, E-Books, Office documents, zip, tar.gz, and more

    # Text editors
    micro
    neovim-remote # send commands to nvim

    # Password management
    pass

    # Work - Beginning Sanskrit
    pandoc
    libwpd

    # PDF
    djvu2pdf # convert djvu to pdf
    diff-pdf # diff PDFs

    # OCR
    tesseract

    # Spotify
    spicetify-cli
  ];

  # required for nushell while XDG_HOME is set
  xdg.enable = true;

  home.file.flavours = {
    source = ./.config/flavours;
    target = "./.config/flavours";
  };

  home.file.flavours-sources = {
    source = ./.config/flavours/sources;
    target = "./Library/Application Support/flavours/base16/sources";
  };

  home.file.flavours-templates = {
    source = ./.config/flavours/templates;
    target = "./Library/Preferences/flavours/templates";
  };

  #----=[ Fonts ]=----#
  fonts = {
    fontconfig = {
      enable = true; # doom emacs dependency
      defaultFonts = {
        serif = [
          "Gentium Plus"
          "Annapurna SIL"
          "Noto Serif"
          "NotoSerif Nerd Font"
        ];
        sansSerif = [
          "Noto Sans"
          "NotoSans Nerd Font"
        ];
        monospace = [
          "VictorMono Nerd Font"
          "NotoSansM Nerd Font Mono"
        ];
      };
    };
  };

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
    oh-my-zsh = {
      enable = true;
    };
  };
  programs.fish = {
    enable = true;
    functions = {
      fish_greeting = {
        description = "";
        body = "colorscript exec fade";
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
      # dircolors ~/dotfiles/nord-dir_colors >/dev/null # nord
      dircolors ~/dotfiles/gruvbox.dircolors >/dev/null # gruvbox

      # direnv integration
      direnv hook fish | source
    '';
  };
  programs.nushell = {
    enable = true;
    shellAliases = {
      cat = "bat";
      top = "btop";
    };
    extraConfig = ''
      # remove startup message
      $env.config.show_banner = false

      # custom commands
      def rebuild [] {
        rebuild-quick
        darwin-rebuild switch --flake ~/dotfiles
        nix store optimise
        # brew-update
        brew autoremove
        brew cleanup
        sudo nix-collect-garbage -d
        nix-collect-garbage -d
        doomsync
      }
      def rebuild-quick [] { darwin-rebuild switch --flake ~/dotfiles }
      def brew-update [] {
        brew update
        brew upgrade
      }
      def doomsync [] {
        doom sync --force
        doom upgrade --force
        doom sync --gc --force
        doom doctor --force
      }
    '';
  };

  home.shellAliases = {
    cat = "bat";
    top = "btop";
    rebuild = "rebuild-update-without-brew-update";
    rebuild-brew = "brew-update;brew-clean";
    rebuild-nix = "nix flake update --flake ~/dotfiles;darwin-rebuild switch --flake ~/dotfiles;nix-optimise";
    rebuild-no-update = "rebuild-quick;nix-optimise;brew-clean;garbage;doom sync";
    rebuild-quick = "darwin-rebuild switch --flake ~/dotfiles";
    rebuild-update = "rebuild-nix;rebuild-brew;garbage;doomsync";
    rebuild-update-without-brew-update = "rebuild-nix;brew-clean;garbage;doomsync";
    brew-update = "brew update;brew upgrade";
    brew-clean = "brew autoremove;brew cleanup";
    doomsync = "doom sync --force;doom upgrade --force;doom sync --gc --force;doom doctor --force";
    garbage = "sudo nix-collect-garbage -d;nix-collect-garbage -d";
    nix-optimise = "nix store optimise";
  };

  # suppress last login message when opening shells
  home.file.".hushlogin" = {
    text = "";
  };

  home.sessionPath = [
    # add doom emacs bin to $PATH
    "~/.emacs.d/bin"

    # add rust cargo installs to $PATH
    "~/.cargo/bin"

    # add tlmgr to $PATH
    # requires brew cask "basictex"
    "/usr/local/texlive/2023basic/bin/universal-darwin"
  ];

  # Shell Tools
  programs.btop = {
    enable = true;
    settings = {
      #* Name of a btop++/bpytop/bashtop formatted ".theme" file, "Default" and "TTY" for builtin themes.
      #* Themes should be placed in "../share/btop/themes" relative to binary or "$HOME/.config/btop/themes"
      # color_theme = "gruvbox_material_dark";

      #* If the theme set background should be shown, set to False if you want terminal background transparency.
      theme_background = true;

      #* Sets if 24-bit truecolor should be used, will convert 24-bit colors to 256 color (6x6x6 color cube) if false.
      truecolor = true;
    };
  };
  programs.eza = {
    enable = true;
    git = true;
    icons = "auto";
    extraOptions = [
      "--all"
      "--group-directories-first"
      "--header"
      "--long"
      "--ignore-glob=.git|.DS_Store"
    ];
  };
  programs.dircolors = {
    enable = true;
  };
  programs.bat = {
    enable = true;
    config = {
      theme = "base16-256";
    };
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.lazygit = {
    enable = true;
  };
  programs.starship = {
    enable = true;
  };
  programs.fd = {
    enable = true;
  };
  programs.zoxide = {
    enable = true;
  };

  # Terminals
  programs.kitty = {
    enable = true;
    darwinLaunchOptions = [ "--directory=~" ];
    extraConfig = ''
      # default shell
      shell nu

      # disable confirm on close
      confirm_os_window_close 0

      # fonts
      font_family FiraCode Nerd Font Mono
      font_size 16.0

      # Devanāgarī support
      # from : https://www.wikiwand.com/en/Devanagari#Unicode
      # The Unicode Standard defines four blocks for Devanāgarī: Devanagari (U+0900–U+097F), Devanagari Extended (U+A8E0–U+A8FF), Devanagari Extended-A (U+11B00–11B5F), and Vedic Extensions (U+1CD0–U+1CFF).
      # symbol_map U+0900–U+097F,U+A8E0–U+A8FF,U+11B00–11B5F,U+1CD0–U+1CFF Annapurna SIL

      # window decorations
      # hide_window_decorations titlebar-only
      hide_window_decorations no

      # transparency
      # background_opacity 0.7

      # blur
      # background_blur 32

      # theme
      include ~/dotfiles/.config/kitty/base16.conf

      # remote control for setting themes (used by flavours)
      # allow_remote_control password
      # remote_control_password "set-theme" set-colors
      # remote_control_password "load-config" load-config
      # remote_control_password "launch" launch

      # startup session
      startup_session ~/dotfiles/.config/kitty/kitty-startup.session
    '';
  };
  programs.alacritty = {
    enable = true;
    settings = {
      general.import = [ "~/dotfiles/.config/alacritty/base16.toml" ];
      # background transparency
      window.opacity = 0.95;
      font.normal = {
        family = "VictorMono Nerd Font";
        style = "Regular";
      };
      font.size = 16.0;
    };
  };
  programs.rio = {
    enable = true;
    settings = {
      shell.program = "nu";
      fonts = {
        family = "VictorMono Nerd Font";
        size = 18;
      };
    };
  };
  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    mouse = true;
    sensibleOnTop = false;
    # shell = "nu";
    terminal = "tmux-direct";
    extraConfig = ''
      set-option -g status off
      bind-key b set-option status
    '';
  };
  programs.zellij = {
    enable = true;
    settings = {
      default_shell = "nu";
    };
  };

  # Text Editors
  programs.helix = {
    enable = true;
    settings = {
      theme = "base16_transparent";
      editor.whitespace.render = "all";
      editor.auto-pairs = false;
    };
  };
  programs.neovim = {
    enable = true;
    extraConfig = ''
      " hide mouse when typing
      let g:neovide_hide_mouse_when_typing = v:false

      " neovide font
      set guifont=VictorMono\ Nerd\ Font:h18

      " neovide transparency
      " everything
      " let g:neovide_opacity = 0.95
      " background only
      let g:neovide_normal_opacity = 0.95

      " Access colors present in 256 colorspace
      let base16colorspace=256

      " color scheme
      colorscheme flavours
    '';
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
  home.file.neovim-colorscheme = {
    source = ./.config/nvim/colors/flavours.vim;
    target = "./.config/nvim/colors/flavours.vim";
  };
  programs.neovide = {
    enable = true;
    settings = {
      #   frame = "none";
    };
  };
  programs.emacs = {
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
  home.file.doom-emacs = {
    source = ./.config/.doom.d;
    target = "./.doom.d";
    recursive = true;
  };
  programs.zed-editor = {
    enable = true;
  };

  # PDF Viewers
  programs.zathura = {
    enable = true;
    extraConfig = ''
      # man zathurarc

      set font "VictorMono Nerd Font 16"

      # color theme
      include ~/dotfiles/.config/zathura/base16-theme

      # default view mode
      set adjust-open "width"

      # remove status bar
      set guioptions ""

      # dark mode
      set recolor "true"

      # window icon
      set window-icon-document "true"
    '';
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

}
