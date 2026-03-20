{ config, pkgs, ... }:
{
  # Sway WM and some system level dependencies
  # https://wiki.nixos.org/wiki/Sway
  environment.systemPackages = with pkgs; [
    wl-clipboard # Copy/Paste functionality.
    mako # Notification utility.
  ];

  # Enables Gnome Keyring to store secrets for applications.
  services.gnome.gnome-keyring.enable = true;

  # In order to unlock the keyring through logins from greeters and
  # screen locking utilities you will need to enable them through PAM.
  security.pam.services = {
    greetd.enableGnomeKeyring = true;
    swaylock.enableGnomeKeyring = true;

    # If using a display manager such as GDM
    #gdm.enableGnomeKeyring = true;
  };

  # https://wiki.nixos.org/wiki/Sway#Inferior_performance_compared_to_other_distributions
  # Enabling realtime may improve latency and reduce stuttering, specially in high load scenarios.
  # Enabling this option allows any program run by the "users" group to request real-time priority.
  security.pam.loginLimits = [
    {
      domain = "@users";
      item = "rtprio";
      type = "-";
      value = 1;
    }
  ];

  # required for later enabling auto mounting of USB drives in home manager
  services.udisks2.enable = true;

  # Make sure hardware accelerated graphics are enabled.
  # This is usually automatically enabled when needed but
  # manually enabling it could prevent errors with Sway and a new install of NixOS.
  hardware.graphics.enable = true;

  # Enable Sway.
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      # these are the defaults
      # not sure which are necessary so I'm leaving them all in for now
      brightnessctl
      foot
      grim
      pulseaudio
      swayidle
      swaylock
      wmenu

      # additions to the defaults
      swaybg
    ];
  };

  security.polkit.enable = true;
}
