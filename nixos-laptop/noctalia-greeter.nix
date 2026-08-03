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

  ### This doesn't seem to work.
  ### This might have more to do with pkexec needing to be run as admin.
  # Skip authentication when syncing to noctalia greeter.
  # use pkaction to see the list of actions
  # https://wiki.nixos.org/wiki/Polkit#Writing_rules
  # https://wiki.archlinux.org/title/Polkit#Bypass_password_prompt
  # security.polkit.extraConfig = ''
  #   polkit.addRule(function (action, subject) {
  #     if (
  #       action.id == "org.noctalia.greeter.apply-appearance"
  #       && subject.isInGroup("wheel")
  #     ) {
  #       return polkit.Result.YES;
  #     }
  #   });
  # '';
}
