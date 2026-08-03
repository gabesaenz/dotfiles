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
    # settings = {
    #   cursor = {
    #     theme = "Bibata-Modern-Ice";
    #     size = 24;
    #     path = "${pkgs.bibata-cursors}/share/icons";
    #   };
    #   keyboard = {
    #     layout = "us";
    #   };
    # };
  };
}
