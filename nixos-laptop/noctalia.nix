{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./noctalia-greeter.nix
  ];

  # binary cache
  nix.settings = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  ### https://docs.noctalia.dev/v5/getting-started/nixos/
  ### Caution
  ### To make Noctalia’s wifi, bluetooth, power-profile, and battery feature available, please ensure the following NixOS options are enabled:
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  services.power-profiles-daemon.enable = true; # or services.tuned.enable
  services.upower.enable = true;

  programs.noctalia = {
    enable = true;

    # Enables NetworkManager, Bluetooth, UPower, and a power profile service.
    recommendedServices.enable = true;

    ### Note
    ### When using the service, it is recommended to enable launch_apps_as_systemd_services, otherwise any apps launched by Noctalia will be terminated when the service restarts.
    # Each of the above modules includes a systemd user service for Noctalia, which can be enabled by setting
    # programs.noctalia.systemd.enable = true;
  };
}
