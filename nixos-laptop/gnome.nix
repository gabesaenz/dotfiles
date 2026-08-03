{
  config,
  pkgs,
  lib,
  ...
}:
{
  # Enable the GNOME Desktop Environment.
  services.desktopManager.gnome.enable = true;
}
