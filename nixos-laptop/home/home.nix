{
  inputs,
  config,
  pkgs,
  ...
}:

{
  imports = [
    inputs.plover-flake.homeManagerModules.plover
  ];

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
    # nov.el
    unzip
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

    # Rust
    rustup
    cargo-binstall # binary installer for rust tools
    cargo-update
    # helpful commands:
    # rustup update --no-self-update stable
    # cargo install-update -a # requires cargo-update

    # Slint
    slint-lsp # required for doom emacs slint-mode
    slint-viewer

    # ZSA Keyboard
    # zsa-udev-rules # not sure if this is necessary
    # wally-cli # firmware tool
    keymapp # configuration GUI
    # kontroll # configuration CLI

    # misc
    translate-shell # translator
    jq # JSON processor

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

  # required for nushell while XDG_HOME is set
  xdg.enable = true;

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

  fonts.fontconfig = {
    enable = true; # doom emacs dependency # required for fonts to work properly
    defaultFonts = {
      serif = [
        "Gentium"
        "Annapurna SIL"
        "Noto Serif"
        "NotoSerif Nerd Font"
      ];
      sansSerif = [
        "Noto Sans"
        "NotoSans Nerd Font"
      ];
      monospace = [
        "Iosevka Nerd Font"
        "VictorMono Nerd Font"
        "NotoSansM Nerd Font Mono"
      ];
      emoji = [
        "Iosevka Nerd Font"
        "Noto Color Emoji"
      ];
    };
    # configFile = {
    #   greek = {
    #     enable = true;
    #     label = "greek";
    #     priority = 90;
    #     text = ''
    #         <?xml version="1.0"?>
    #         <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
    #         <fontconfig>
    #           <!-- Default font for greek (no fc-match pattern) -->
    #           <match>
    #             <test compare="contains" name="lang">
    #               <string>el</string>
    #             </test>
    #             <edit mode="prepend" name="family">
    #               <string>Gentium</string>
    #             </edit>
    #           </match>
    #           <match>
    #             <test compare="contains" name="lang">
    #               <string>grc</string>
    #             </test>
    #             <edit mode="prepend" name="family">
    #               <string>Gentium</string>
    #             </edit>
    #           </match>
    #           <!-- Default monospace fonts -->
    #           <match>
    #             <test compare="contains" name="lang">
    #               <string>el</string>
    #             </test>
    #             <test qual="any" name="family">
    #               <string>monospace</string>
    #             </test>
    #             <edit name="family" mode="prepend" binding="same">
    #               <string>Iosevka Nerd Font</string>
    #             </edit>
    #           </match>
    #           <match>
    #             <test compare="contains" name="lang">
    #               <string>grc</string>
    #             </test>
    #             <test qual="any" name="family">
    #               <string>monospace</string>
    #             </test>
    #             <edit name="family" mode="prepend" binding="same">
    #               <string>Iosevka Nerd Font</string>
    #             </edit>
    #           </match>
    #           <!-- Remove all other monospace fonts from Greek Unicode ranges -->
    #           <match>
    #             <test target="font" name="family" compare="not_eq">
    #             <string>Iosevka Nerd Font</string>
    #             </test>
    #             <test qual="any" name="family">
    #               <string>monospace</string>
    #             </test>
    #             <edit name="charset" mode="assign">
    #             <!-- Greek and Coptic -->
    #             <minus>
    #               <name>charset</name>
    #               <range>
    #                 <int>0x0370</int>
    #                 <int>0x03FF</int>
    #               </range>
    #             </minus>
    #             <!-- Phonetic Extensions -->
    #             <minus>
    #               <name>charset</name>
    #               <range>
    #                 <int>0x1D00</int>
    #                 <int>0x1D7F</int>
    #               </range>
    #             </minus>
    #             <!-- Phonetic Extensions Supplement -->
    #             <minus>
    #               <name>charset</name>
    #               <range>
    #                 <int>0x1D80</int>
    #                 <int>0x1DBF</int>
    #               </range>
    #             </minus>
    #             <!-- Greek Extended -->
    #             <minus>
    #               <name>charset</name>
    #               <range>
    #                 <int>0x1F00</int>
    #                 <int>0x1FFF</int>
    #               </range>
    #             </minus>
    #             <!-- Letterlike Symbols -->
    #             <minus>
    #               <name>charset</name>
    #               <range>
    #                 <int>0x2100</int>
    #                 <int>0x214F</int>
    #               </range>
    #             </minus>
    #             <!-- Latin Extended-E -->
    #             <minus>
    #               <name>charset</name>
    #               <range>
    #                 <int>0xAB30</int>
    #                 <int>0xAB6F</int>
    #               </range>
    #             </minus>
    #             <!-- Ancient Greek Numbers -->
    #             <minus>
    #               <name>charset</name>
    #               <range>
    #                 <int>0x10140</int>
    #                 <int>0x1018F</int>
    #               </range>
    #             </minus>
    #             <!-- Ancient Symbols -->
    #             <minus>
    #               <name>charset</name>
    #               <range>
    #                 <int>0x10190</int>
    #                 <int>0x101CF</int>
    #               </range>
    #             </minus>
    #             <!-- Ancient Greek Musical Notation -->
    #             <minus>
    #               <name>charset</name>
    #               <range>
    #                 <int>0x1D200</int>
    #                 <int>0x1D24F</int>
    #               </range>
    #             </minus>
    #           </edit>
    #         </match>
    #         <!-- Add monospace font to Greek Unicode ranges -->
    #         <match>
    #           <test qual="any" name="family">
    #             <string>monospace</string>
    #           </test>
    #           <edit name="family" mode="prepend" binding="same">
    #             <string>Iosevka Nerd Font</string>
    #           </edit>
    #             <edit name="charset" mode="assign">
    #             <!-- Greek and Coptic -->
    #               <name>charset</name>
    #               <range>
    #                 <int>0x0370</int>
    #                 <int>0x03FF</int>
    #               </range>
    #             <!-- Phonetic Extensions -->
    #               <name>charset</name>
    #               <range>
    #                 <int>0x1D00</int>
    #                 <int>0x1D7F</int>
    #               </range>
    #             <!-- Phonetic Extensions Supplement -->
    #               <name>charset</name>
    #               <range>
    #                 <int>0x1D80</int>
    #                 <int>0x1DBF</int>
    #               </range>
    #             <!-- Greek Extended -->
    #               <name>charset</name>
    #               <range>
    #                 <int>0x1F00</int>
    #                 <int>0x1FFF</int>
    #               </range>
    #             <!-- Letterlike Symbols -->
    #               <name>charset</name>
    #               <range>
    #                 <int>0x2100</int>
    #                 <int>0x214F</int>
    #               </range>
    #             <!-- Latin Extended-E -->
    #               <name>charset</name>
    #               <range>
    #                 <int>0xAB30</int>
    #                 <int>0xAB6F</int>
    #               </range>
    #             <!-- Ancient Greek Numbers -->
    #               <name>charset</name>
    #               <range>
    #                 <int>0x10140</int>
    #                 <int>0x1018F</int>
    #               </range>
    #             <!-- Ancient Symbols -->
    #               <name>charset</name>
    #               <range>
    #                 <int>0x10190</int>
    #                 <int>0x101CF</int>
    #               </range>
    #             <!-- Ancient Greek Musical Notation -->
    #               <name>charset</name>
    #               <range>
    #                 <int>0x1D200</int>
    #                 <int>0x1D24F</int>
    #               </range>
    #           </edit>
    #         </match>
    #       </fontconfig>
    #     '';
    #   };
    # };
  };

  # Touchpad gestures
  services.fusuma = {
    enable = true;
    settings = { };
  };

  # hide mouse cursor when not in use
  services.unclutter.enable = true;

  # cloud file storage
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

  # doom emacs dependency for emms
  # services.mpd.enable = true;
  # services.mpd.musicDirectory = /home/gabe/Music;

  # Web browsers
  programs.firefox.enable = true;
  programs.chromium.enable = true;

  # Shells
  # shells must be enabled for shell tool integrations to work
  programs.bash.enable = true;
  programs.zsh.enable = true;
  programs.zsh.autosuggestion.enable = true;
  programs.nushell = {
    enable = true;
    shellAliases = {
      cat = "bat";
      top = "btop";
    };
    extraConfig = ''
      # remove startup message
      $env.config.show_banner = false
    '';
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
  # doom emacs dependency
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

  # Plover stenography
  programs.plover = {
    enable = true;
    # Select individual plugins to include
    package = inputs.plover-flake.packages.${pkgs.stdenv.hostPlatform.system}.plover.withPlugins (
      ps: with ps; [
        # plover-lapwing-aio
      ]
    );

    # Or, use `plover-full` if you want Plover with all the plugins installed:
    # package = inputs.plover-flake.packages.${pkgs.stdenv.hostPlatform.system}.plover-full;

    # Example settings given in installation instructions
    # settings = {
    #   "Machine Configuration" = {
    #     machine_type = "Gemini PR";
    #     auto_start = true;
    #   };
    #   "Output Configuration".undo_levels = 100;
    # };
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
    # required for fcitx in QT and GTK apps
    QT_IM_MODULE = "fcitx";
    GTK_IM_MODULE = "fcitx";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
