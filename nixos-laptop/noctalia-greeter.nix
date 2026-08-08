{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    inputs.noctalia-greeter.nixosModules.default
  ];

  programs.noctalia-greeter = {
    enable = true;
    # Optional: extra flags after `--` on noctalia-greeter-session
    # greeter-args = "";
    # Full declarative greeter.toml (overwritten on each activation).
    # See examples/greeter.toml for every key (appearance.palette, output, …).
    settings = {
      appearance = {
        # Hide the Noctalia brand logo on the login screen.
        hide_logo = true;
      };
      # Seconds with no input before blanking outputs; 0 disables (range 0-86400).
      idle.timeout = 300;
      # cursor = {
      #   theme = "Bibata-Modern-Ice";
      #   size = 24;
      #   path = "${pkgs.bibata-cursors}/share/icons";
      # };
      # keyboard = {
      #   layout = "us";
      # };
    };
  };

  # Skip authentication when syncing to noctalia greeter.
  # requires "Greeter Sync Privilege Command" in noctalia set to "sudo"
  security.sudo = {
    extraRules = [
      {
        commands = [
          {
            command = "/run/current-system/sw/bin/noctalia-greeter-apply-appearance /run/user/1000/noctalia-greeter-sync";
            options = [ "NOPASSWD" ];
          }
        ];
        groups = [ "wheel" ];
      }
    ];
  };
}
