# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    /etc/nixos/hardware-configuration.nix

    # Home Manager
    <home-manager/nixos>

    # nix-community binary cache
    /etc/nixos/cachix.nix
  ];

  # Emacs overlay
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
    }))
  ];

  # Change the location of configuration.nix
  # Run this the first time:
  # sudo -i nixos-rebuild switch -I nixos-config=$HOME/dotfiles/nix/nixos-mba/configuration.nix
  # The reboot to update the environment variables.
  # Then run this any time after that:
  # sudo -i nix-channel --update;sudo -i nixos-rebuild switch
  environment.variables = {
    NIXOS_CONFIG = "/home/gabe/dotfiles/nix/nixos-mba/configuration.nix";
    DOOMDIR = "/home/gabe/dotfiles/.config/.doom.d"; # doom emacs config folder
  };

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Optimize the store
  # https://nixos.wiki/wiki/Storage_optimization#Optimising_the_store
  nix.settings.auto-optimise-store = true;

  # Garbage collection
  # https://nixos.wiki/wiki/Storage_optimization#Automation
  # Also run these commands to manually clean up garbage:
  # nix-collect-garbage -d
  # sudo nix-collect-garbage -d
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  nix.extraOptions = ''
    min-free = ${toString (100 * 1024 * 1024)}
    max-free = ${toString (1024 * 1024 * 1024)}
  '';

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-adbdd4a3-bce7-43b6-9e24-ae2cbb500449".device = "/dev/disk/by-uuid/adbdd4a3-bce7-43b6-9e24-ae2cbb500449";
  boot.initrd.luks.devices."luks-adbdd4a3-bce7-43b6-9e24-ae2cbb500449".keyFile = "/crypto_keyfile.bin";

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable gpg
  programs.gnupg.agent.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Fonts
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    annapurna-sil
    fira-code
    fira-code-symbols
    (nerdfonts.override { fonts = [ "Noto" "FiraCode" ]; })
  ];

  fonts.fontconfig.enable = true; # doom emacs dependency

  # Set default shell
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  environment.shells = with pkgs; [ fish ];

  # Emacs
  services.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
  };

  # Users
  users.users.gabe = {
    isNormalUser = true;
    description = "gabe";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
  };

  # Home Manager
  home-manager.users.gabe = { pkgs, ... }:
  {
    home.stateVersion = "23.05";
    home.packages = with pkgs; [
      # Shell tools
      exa
      bat

      # Text editing
      helix

      # Password management
      pass

      # Web browsing
      firefox

      # Dropbox client
      maestral
      maestral-gui
    ];
    programs.git = {
      enable = true;
      userEmail = "29664619+gabesaenz@users.noreply.github.com";
      extraConfig = {
        init.defaultBranch = "main";
      };
    };
    programs.fish = {
      enable = true;
      functions = {
        fish_greeting = {
	        description = "";
	        body = "";
	      };
      };
      shellAliases = {
        ls = "exa -ahl --icons --color-scale --group-directories-first --git";
        cat = "bat";
      };
      shellInit = ''
        # add doom emacs bin to $PATH
        fish_add_path ~/.emacs.d/bin
      '';
    };
    programs.starship.enable = true;
    programs.alacritty.enable = true;
    programs.alacritty.settings = {
      font = {
        normal = {
          family = "NotoSansM Nerd Font Mono";
        };
        size = 14.0;
      };
      window.decorations = "none";
      shell.program = "fish";
    };

    fonts.fontconfig.enable = true; # doom emacs dependency

    # Email
    programs.offlineimap.enable = true; # doom emacs mu4e dependency
    programs.msmtp.enable = true;
    accounts.email = {
      maildirBasePath = "${config.users.users.gabe.home}/.mail";
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

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "gabe";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
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
    nodePackages.stylelint
    nodePackages.js-beautify
    mu
    pandoc # fixes doom doctor :lang markdown warning
    html-tidy # fixes doom doctor :lang web warning
    imagemagick # fixes doom doctor :email mu4e warning

    # Spellchecking - used by emacs
    (aspellWithDicts (dicts: with dicts; [
      en # English
      en-computers # English Computer Jargon
      en-science # English Scientific Jargon
      la # Latin
      el # Greek
      grc # Ancient Greek
      de # German
      de-alt # German Old-Spelling
    ]))
    hunspell
    # hunspell dictionaries
    mythes # thesaurus
    hunspellDicts.en_US-large # English (United States) Large
    hunspellDicts.en_GB-large # English (United Kingdom) Large
    hunspellDicts.de_DE # German (Germany)
    enchant

    # Rust
    cargo
    clippy
    rustc
    rustfmt
    rust-analyzer
    bacon
  ];

  programs.npm.enable = true; # doom emacs dependency

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
