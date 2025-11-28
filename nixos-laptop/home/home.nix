{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "gabe";
  home.homeDirectory = "/home/gabe";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # START copied over from mac nix config
    # doom emacs dependencies
    # required
    git
    ripgrep
    #optional
    coreutils # optional # possibly causing a build error with home manager
    fd
    clang

    # doom emacs doom doctor suggestions
    # vterm
    cmake
    gnumake # fix missing make command warning
    # lsp
    nodejs # fix missing npm warning
    # data
    libxml2 # fix missing xmllint
    # markdown
    markdownlint-cli
    proselint
    pandoc
    go-grip
    # org
    wl-clipboard
    gnome-screenshot
    graphviz
    # web
    html-tidy
    stylelint
    jsbeautifier
    # email mu4e
    mu
    # other
    cmigemo
    gnugrep # gnu pcre warning
    # coreutils-prefixed # gnu ls warning # was clashing with coreutils above
    editorconfig-core-c # editorconfig
    gnuplot # org-plot/gnuplot dependency
    nixfmt-rfc-style
    # pngpaste # org-download-clipboard dependency # not available on linux
    shellcheck
    shfmt
    # nodePackages.stylelint
    # nodePackages.js-beautify
    # nodePackages.npm # npm warning
    # nodePackages.prettier # code formatting dependency
    wordnet # for lookup with offline dictionary
    imagemagick # fix email mu4e warning
    (aspellWithDicts (
      dicts: with dicts; [
        en # English
        de # German
        la # Latin
        grc # Ancient Greek
      ]
    ))

    # Dropbox
    # maestral # build error
    # maestral-gui # build error

    # Rust
    rustup
    cargo-binstall # binary installer for rust tools

    # misc
    translate-shell # translator
    jq # JSON processor
    # END copied over from mac nix config

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    #----=[ Fonts ]=----#
    # emacs unicode recommendations
    dejavu_fonts
    noto-fonts

    gentium # gentium plus for greek
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji
    noto-fonts-color-emoji
    nerd-fonts.fira-code
    nerd-fonts.iosevka
    nerd-fonts.noto
    nerd-fonts.victor-mono
    nerd-fonts.symbols-only
    # Devanāgarī
    annapurna-sil
    # emacs icons
    emacs-all-the-icons-fonts

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # input methods
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.waylandFrontend = true; # prevent error messages in Wayland
    fcitx5.addons = with pkgs; [
      fcitx5-configtool
      fcitx5-gtk

      # Chinese
      fcitx5-chinese-addons
      fcitx5-table-extra

      # Japanese
      fcitx5-mozc

      # Korean
      fcitx5-hangul

      # multiple languages
      fcitx5-m17n
      fcitx5-table-other
    ];
  };

  # doom emacs dependency
  fonts.fontconfig.enable = true; # required for fonts to work properly

  services.dropbox = {
    enable = true;
  };

  # Sway WM
  services.gnome-keyring.enable = true;
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # Fixes common issues with GTK 3 apps
    config = rec {
      modifier = "Mod4";
      # default terminal
      terminal = "alacritty";
      startup = [
        # Launch Firefox on start
        { command = "firefox"; }
      ];
    };
  };

  # emacs
  services.emacs.enable = true;
  # the emacs service will use doom-emacs
  programs.doom-emacs = {
    enable = true;
    doomDir = ./doomdir;
    # copied this next line over from the mac config. not sure if it's necessary.
    # doomLocalDir = "~/.local/share/nix-doom";
  };

  # doom emacs dependency
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # terminal emulator
  programs.alacritty = {
    enable = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        email = "29664619+gabesaenz@users.noreply.github.com";
      };
      # credential.helper = "osxkeychain";
      init.defaultBranch = "main";
    };
    # ignores = [ ".DS_Store" ];
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

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/gabe/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
