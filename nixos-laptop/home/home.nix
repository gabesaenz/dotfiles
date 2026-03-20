{
  inputs,
  config,
  pkgs,
  ...
}:

{
  imports = [
    inputs.plover-flake.homeManagerModules.plover
    ./emacs
    ./ocr.nix
    ./sway.nix
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
  home.stateVersion = "26.05"; # Please read the comment before changing.

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

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

    # archive tools
    unrar
    p7zip

    # misc
    translate-shell # translator
    jq # JSON processor
    tlrc # cli for tldr - simplified man pages
    sdcv # stardict cli

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    #----=[ Fonts ]=----#
    gentium # gentium plus for greek
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    nerd-fonts.fira-code
    nerd-fonts.iosevka
    nerd-fonts.noto
    nerd-fonts.victor-mono
    nerd-fonts.symbols-only
    # Devanāgarī
    annapurna-sil

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # required for nushell while XDG_HOME is set
  xdg.enable = true;

  # enable this so that fcitx works with flatpak
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  xdg.portal.config.common.default = "*";

  # icons for use with xdg.desktopEntries
  # home.file."human-japanese-icon" = {
  #   source = icons/human-japanese.png;
  #   target = "icons/human-japanese.png";
  # };

  # desktop shortcuts
  # xdg.desktopEntries = {
  #   "human-japanese" = {
  #     name = "Human Japanese";
  #     genericName = "Human Japanese";
  #     exec = "firefox --new-window https://www.humanjapanese.com/content/human-japanese-intermediate";
  #     icon = "${config.home.homeDirectory}/icons/human-japanese.png";
  #     type = "Application";
  #     terminal = false;
  #     categories = [ "Education" ];
  #   };
  # };

  # input methods
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.waylandFrontend = true; # prevent error messages in Wayland
    fcitx5.addons = with pkgs; [
      qt6Packages.fcitx5-configtool
      fcitx5-gtk

      # Chinese
      qt6Packages.fcitx5-chinese-addons
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
    enable = true; # required for fonts to work properly
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
        # "Iosevka NFM Greek"
      ];
      emoji = [
        # "Iosevka Nerd Font"
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

  # tldr - simplified man pages
  services.tldr-update.enable = true;

  # night light / red shift
  # https://wiki.nixos.org/wiki/Gammastep
  # services.gammastep = {
  #   enable = true;
  #   # Schedule and set time range for dusk/dawn
  #   duskTime = "18:35-20:15";
  #   dawnTime = "6:00-7:45";
  #   # Temperature to use at night/day (between 1000 and 25000 Kelvin).
  #   temperature = {
  #     day = 5500;
  #     night = 3700;
  #   };
  #   # Tray Icon
  #   tray = true;
  #   enableVerboseLogging = true;
  #   settings = {
  #     general = {
  #       adjustment-method = "randr";
  #     };
  #     randr = {
  #       screen = 0;
  #     };
  #   };
  # };

  # night light / red shift
  # https://wiki.nixos.org/wiki/Wlsunset
  services.wlsunset = {
    enable = true;
    temperature = {
      day = 6500;
      night = 3000;
    };
    sunrise = "06:00";
    sunset = "18:00";
  };

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
    plugins = with pkgs.nushellPlugins; [ polars ];
    extraConfig = ''
      # remove startup message
      $env.config.show_banner = false
    '';
  };
  home.shellAliases = {
    cat = "bat";
    top = "btop";
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
    settings = {
      general.import = [ "~/dotfiles/.config/alacritty/base16.toml" ];
      # background transparency
      window.opacity = 0.95;
      font.normal = {
        family = "monospace";
        style = "Regular";
      };
      font.size = 14.0;
    };
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
    settings = {
      "Machine Configuration" = {
        machine_type = "Gemini PR";
        auto_start = true;
      };
      # "Output Configuration".undo_levels = 100;
      # Configure the input device or it won't actually work
      "Gemini PR".port = "/dev/serial/by-id/usb-ZSA_Technology_Labs_Moonlander_Mark_I_vqdxO_Eexnev-if02";
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

    # set the order of stardict cli results
    ".config/sdcv_ordering".source = sdcv/sdcv_ordering;
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

    # stardict CLI dictionaries folder
    STARDICT_DATA_DIR = "${config.home.homeDirectory}/Dictionaries/stardict";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
