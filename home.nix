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
    translate-shell # translator

    # Text editors
    micro

    # Password management
    pass

    # Work - Beginning Sanskrit
    pandoc
    libwpd

    # PDF
    djvu2pdf # convert djvu to pdf
    sioyek
    zathura

    # Spotify
    spicetify-cli
  ];

  home.file.flavours = {
    source = ./.config/flavours;
    target = "./.config/flavours";
  };

  home.file.flavours-sources = {
    source = ./.config/flavours/sources;
    target = "./Library/Application Support/flavours/base16/sources";
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
    shellAliases = {
      cat = "bat";
      top = "btop";
      rebuild = "rebuild-nix && rebuild-brew && garbage && doomsync";
      rebuild-nix = "nix flake update ~/dotfiles/ && darwin-rebuild switch --flake ~/dotfiles/ && nix store optimise";
      rebuild-brew = "brew update && brew upgrade && brew autoremove && brew cleanup";
      rebuild-quick = "darwin-rebuild switch --flake ~/dotfiles/";
      doomsync = "doom sync && doom upgrade && doom sync && doom doctor";
      garbage = "sudo nix-collect-garbage -d && nix-collect-garbage -d";
    };
  };

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
    icons = true;
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
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.lazygit = {
    enable = true;
  };
  programs.starship.enable = true;

  # Terminals
  programs.kitty = {
    enable = true;
    darwinLaunchOptions = [ "--directory=~" ];
    extraConfig = ''
      # default shell
      shell fish

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
  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    mouse = true;
    sensibleOnTop = false;
    shell = "/Users/gabesaenz/.nix-profile/bin/fish";
    terminal = "tmux-direct";
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
      editor.whitespace.render = "all";
      editor.auto-pairs = false;
    };
  };
  programs.neovim = {
    enable = true;
    defaultEditor = false;
    extraConfig = ''
      " hide mouse when typing
      let g:neovide_hide_mouse_when_typing = v:false
    '';
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

}
