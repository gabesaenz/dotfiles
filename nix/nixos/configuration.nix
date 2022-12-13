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

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "nixos"; # Define your hostname.
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Enable xmonad window manager
  # services.xserver.windowManager.xmonad.enable = true;
  services.xserver.windowManager = {
    xmonad = {
      enable = true;
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
    };
  };

  # LeftWM
  services.xserver.windowManager.leftwm.enable = true;

  # Set default window manager
  # services.xserver.displayManager.defaultSession = "none+xmonad";
  services.xserver.displayManager.defaultSession = "none+leftwm";

  # Enable remote desktop
  #services.xrdp.enable = true;
  #services.xrdp.defaultWindowManager = "xmonad";
  #networking.firewall.allowedTCPPorts = [ 3389 ];
  # Soon: services.xrdp.openFirewall = true;
  # from https://nixos.wiki/wiki/Remote_Desktop

  # Disable xterm
  #services.xserver.desktopManager.xterm.enable = false;

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

  # Enable sound with pipewire.
  sound.enable = true;
  # Bluetooth config for PulseAudio
  #  not used since PulseAudio needs to be disabled for pipewire to work
  #hardware.pulseaudio = {
  #  enable = true;
  #  extraModules = [ pkgs.pulseaudio-modules-bt ];
  #  package = pkgs.pulseaudioFull;
  #};
  #hardware.pulseaudio.extraConfig = "
  #  load-module module-switch-on-connect
  #";
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

  # Enable bluetooth support
  hardware.bluetooth.enable = true;
  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
    };
  };
  # Bluetooth management with blueman
  services.blueman.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

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
      firefox
      neovide # neovim GUI

      # Rust
      rustup

      # flatpak # for fightcade

      # Flutter
      # flutter
      # Flutter Linux requirements
      # clang
      # cmake
      # gtk3
      # ninja
      # pkg-config

      # xmonad
      # haskellPackages.haskell-language-server
      # haskellPackages.hoogle
      # cabal-install
      # ghc # needed for cabal
      # stack
    ];
    programs.fish.enable = true;
    programs.starship.enable = true;
    programs.alacritty.enable = true;

    programs.neovim.enable = true;
    programs.neovim.viAlias = true;
    programs.neovim.vimAlias = true;
    # programs.neovim.configure = {
    #   # custom config goes here
    # };
  };

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

  # Enable opengl
  hardware.opengl.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git

    # xmonad
    dmenu
    gmrun

    # LeftWM
    rofi # default command runner
    openssl # required for leftwm-theme

    # doomemacs
    # required dependencies
    ripgrep
    findutils # GNU Find
    # optional dependencies
    coreutils
    fd
    clang

    cachix # access community binary caches, for example: the emacs overlay

    # unfree
    # steam # unfree
    spotify # unfree
  ];

  # Steam
  programs.steam.enable = true;

  # flatpak package manager
  services.flatpak.enable = true;

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
  # Enable automatic reboot when necessary to finish and upgrade
  #system.autoUpgrade.allowReboot = true;

}
