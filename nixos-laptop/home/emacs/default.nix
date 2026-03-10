{ config, pkgs, ... }:
{
  imports = [
    ./w3m
  ];
  home.packages = with pkgs; [
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
    nixfmt
    # pngpaste # org-download-clipboard dependency # not available on linux
    shellcheck
    shfmt
    mpc # emms media player
    mpv # emms media player
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
    ### Fonts
    # emacs unicode recommendations
    dejavu_fonts
    noto-fonts
    # emacs icons
    emacs-all-the-icons-fonts
  ];
  fonts.fontconfig = {
    enable = true; # doom emacs dependency
  };
  # emacs
  services.emacs = {
    enable = true;
    defaultEditor = true;
    startWithUserSession = "graphical";
    # not sure if the following three options are necessary
    client.enable = true;
    client.arguments = [
      "--create-frame"
      "--no-wait"
      "--alternate-editor=''"
    ];
    socketActivation.enable = true;
  };
  # the emacs service will use doom-emacs
  programs.doom-emacs = {
    enable = true;
    doomDir = "${config.xdg.configHome}/doom-emacs";
    extraPackages = (
      epkgs: [
        (epkgs.melpaBuild {
          pname = "sdcv-pure";
          version = "9999snapshot1";
          packageRequires = [ epkgs.popup ];
          src = builtins.fetchTree {
            type = "github";
            owner = "jsntn";
            repo = "sdcv-pure.el";
            rev = "22184f446457f3647932dfa74ca812e980493378";
          };
        })
      ]
    );
  };
  ### Doom Emacs config files
  ### These are applied first and can be added to with "text" attributes elsewhere.
  xdg.configFile."doom-emacs" = pkgs.lib.mkFirst ({
    source = ./doom;
    recursive = true;
  });
  # doom emacs dependency for emms
  services.mpd.enable = true;
  services.mpd.musicDirectory = "${config.home.homeDirectory}/Music";
}
