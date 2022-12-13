{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
      bat
  ];

  # Fonts
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    # Devanagari
    annapurna-sil
    # (nerdfonts.override { fonts = [ "FireCode" ]; })
  ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  programs.fish.enable = true;

  # Home Manager
  imports = [ <home-manager/nix-darwin> ];

  users.users.gabesaenz = {
    name = "Gabe Saenz";
    home = "/Users/gabesaenz";
  };
  home-manager.users.gabesaenz = { pkgs, ... }: {
    home.stateVersion = "22.05";
    home.packages = with pkgs; [
      exa
      # neovide
      alacritty
      rustup
      # rustdesk # not supported on darwin 2022-12-02
      # pomotroid # not supported on darwin 2022-12-12
    ];
    programs.starship.enable = true;
    programs.fish.enable = true;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
