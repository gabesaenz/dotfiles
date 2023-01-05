# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # Thirdy party nix caches
      ./cachix.nix

      # Home Manager
      <home-manager/nixos>
    ];

  # Optimise Nix Storage
  nix.settings.auto-optimise-store = true;

  # Garbage Collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  # run if free space is low
  nix.extraOptions = ''
    min-free = ${toString (100 * 1024 * 1024)}
    max-free = ${toString (1024 * 1024 * 1024)}
  '';

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "NixOS-Gabe"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-gtk fcitx5-m17n fcitx5-configtool fcitx5-chinese-addons ];
    # ibus.engines = with pkgs.ibus-engines; [ anthy libpinyin ];
  };

  # Fonts
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    annapurna-sil
    fira-code
    fira-code-symbols
    (nerdfonts.override { fonts = [ "Noto" "FiraCode" ]; })
    # Yoru AwesomeWM Theme
    # roboto
    # material-design-icons
    # Couldn't find all of them through Nix so let's see if the way they're packaged in the theme works
  ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  # Enable xmonad window manager
  # services.xserver.windowManager.xmonad.enable = true;
  # services.xserver.windowManager = {
    # xmonad = {
      # enable = true;
      #enableContribAndExtras = true;
      #extraPackages = haskellPackages: [
        #haskellPackages.dbus
        #haskellPackages.List
        #haskellPackages.monad-logger
        #haskellPackages.xmonad
        #haskellPackages.xmonad-contrib
        #haskellPackages.containers
      #];
      #config = pkgs.lib.readFile ./xmonad-config/Main.hs;
    # };
  # };

  # LeftWM
  # services.xserver.windowManager.leftwm.enable = true;

  # AwesomeWM
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.defaultSession = "none+awesome";
  services.xserver.windowManager.awesome = {
    enable = true;
    luaModules = with pkgs.luaPackages; [
      luarocks # is the package manager for Lua modules
      luadbi-mysql # Database abstraction layer
    ];
  };

  # Set default window manager
  # services.xserver.displayManager.defaultSession = "none+xmonad";
  # services.xserver.displayManager.defaultSession = "none+leftwm";

  # required by Flatpak (and others?)
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];

  # Enable remote desktop
  # services.xrdp.enable = true;
  # services.xrdp.defaultWindowManager = "awesome";
  # networking.firewall.allowedTCPPorts = [ 3389 ];
  # Soon: services.xrdp.openFirewall = true;
  # from https://nixos.wiki/wiki/Remote_Desktop

  # Disable xterm
  services.xserver.desktopManager.xterm.enable = false;

  # Set default shell
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  environment.shells = with pkgs; [ fish ];

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Pipewire
  # Remove sound.enable or turn it off if you had it set previously, it seems to cause conflicts with pipewire
  sound.enable = false;

  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
    config.pipewire = {
      "context.properties" = {
        #"link.max-buffers" = 64;
        "link.max-buffers" = 16; # version < 3 clients can't handle more than this
        "log.level" = 2; # https://docs.pipewire.org/page_daemon.html
        #"default.clock.rate" = 48000;
        #"default.clock.quantum" = 1024;
        #"default.clock.min-quantum" = 32;
        #"default.clock.max-quantum" = 8192;
      };
    };
    media-session.config.bluez-monitor.rules = [
      {
        # Matches all cards
        matches = [ { "device.name" = "~bluez_card.*"; } ];
        actions = {
          "update-props" = {
            "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
            # mSBC is not expected to work on all headset + adapter combinations.
            "bluez5.msbc-support" = true;
            # SBC-XQ is not expected to work on all headset + adapter combinations.
            "bluez5.sbc-xq-support" = true;
          };
        };
      }
      {
        matches = [
          # Matches all sources
          { "node.name" = "~bluez_input.*"; }
          # Matches all outputs
          { "node.name" = "~bluez_output.*"; }
        ];
      }
    ];
  };

  environment.etc = {
	  "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
      bluez_monitor.properties = {
        ["bluez5.enable-sbc-xq"] = true,
        ["bluez5.enable-msbc"] = true,
        ["bluez5.enable-hw-volume"] = true,
        ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
      }
    '';
  };

  # Enable bluetooth support
  # hardware.firmware = [ pkgs.rtl8761b-firmware ]; #unfree
  hardware.bluetooth.enable = true;
  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
    };
  };
  # hardware.bluetooth.package = pkgs.bluezFull;
  # Bluetooth management with blueman
  services.blueman.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Moonlander
  hardware.keyboard.zsa.enable = true;

  # VMs
  # virtualisation.lxd.enable = true; # requires "lxd" user group

  # Groups
  # users.groups.plugdev = { };
  # users.groups.uaccess = { };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gabesaenz = {
    isNormalUser = true;
    description = "Gabe Saenz";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
  };

  # Home Manager
  home-manager.users.gabesaenz = { pkgs, ... }: {
    home.stateVersion = "22.05";
    home.packages = with pkgs; [
      # Moonlander
      wally-cli

      # shell tools
      exa
      bat
      neofetch

      # fish plugins
      fzf
      fishPlugins.fzf-fish

      firefox
      chromium
      neovide # neovim GUI
      rust-motd
      figlet # used for rust-motd banner

      pavucontrol # volume control
      volumeicon

      # Work - Beginning Sanskrit
      pandoc
      libreoffice
      libwpd

      # Rust
      cargo
      clippy
      rustc
      rustfmt
      rust-analyzer
      bacon

      maestral # dropbox client

      ncspot # spotify frontend

      # Media players
      clementine
      kaffeine
      sayonara

      # Retroarch
      (retroarch.override {
        cores = [
          libretro.fbneo
        ];
      })
      libretro.fbneo
    ];

    programs.fish = {
      enable = true;
      functions = {
        fish_greeting = {
	        description = "";
	        body = "rust-motd";
	      };
      };
      shellAliases = {
        ls = "exa -ahl --icons --color-scale --group-directories-first --git";
        cat = "bat";
      };
      # plugins = [
        # { name = "fzf"; src = pkgs.fishPlugins.fzf-fish.src; }
      # ];
    };
    programs.starship.enable = true;
    programs.alacritty.enable = true;

    programs.neovim.enable = true;
    programs.neovim.viAlias = true;
    programs.neovim.vimAlias = true;
    # programs.neovim.configure = {
    #   # custom config goes here
    # };

    services.spotifyd.enable = true;
    # services.spotifyd.settings {
    #   global = {
    #     bitrate = 320;
    #   };
    # }

    # hide the mouse cursor when inactive
    services.unclutter.enable = true;

    # Adjust screen temperature depending on the time of day
    services.redshift.enable = true;
    services.redshift.provider = "geoclue2";

    # Support for buttons on Bluetooth headsets
    systemd.user.services.mpris-proxy = {
      Unit.Description = "Mpris proxy";
      Unit.After = [ "network.target" "sound.target" ];
      Service.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
      Install.WantedBy = [ "default.target" ];
    };
  };

    # Location information
    services.geoclue2.enable = true;

  # Enable emacs server
  services.emacs.enable = true;
  services.emacs.package = pkgs.emacsUnstable;

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
    }))
  ];

  # Allow unfree packages
  # required for nvidia drivers
  nixpkgs.config.allowUnfree = true;

  # Enable proprietary nvidia drivers
  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.screenSection = ''
    Option         "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
    Option         "AllowIndirectGLXProtocol" "off"
    Option         "TripleBuffer" "on"
    Option         "SLI" "AFR"
  '';

  # Optionally, you may need to select the appropriate driver version for your specific GPU.
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  # Enable opengl
  hardware.opengl.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    google-chrome # unfree
    unzip

    # doomemacs
    # required dependencies
    ripgrep
    findutils # GNU Find
    # optional dependencies
    coreutils
    fd
    clang

    cachix # access community binary caches, for example: the emacs overlay

  ];

  # Steam
  programs.steam.enable = true; # unfree

  # flatpak package manager
  # services.flatpak.enable = true;

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
  system.stateVersion = "22.05"; # Did you read the comment?

  # Enable automatic upgrades
  system.autoUpgrade.enable = true;
  # Enable automatic reboot when necessary to finish an upgrade
  #system.autoUpgrade.allowReboot = true;

}
