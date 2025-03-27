# Run this the first time then use "rebuild" or "rebuild-quick" from then on.
# nix flake update ~/dotfiles/nix/mac/ && darwin-rebuild switch --flake ~/dotfiles/nix/mac/

{
  description = "Darwin configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-24.11-darwin";
    darwin.url = "github:lnl7/nix-darwin/nix-darwin-24.11";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # darwin-emacs.url = "github:c4710n/nix-darwin-emacs";
    # darwin-emacs.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      darwin,
      # darwin-emacs,
      ...
    }:
    {
      darwinConfigurations = {
        Gabe-Mac = darwin.lib.darwinSystem {
          system = "x86_64-darwin";
          modules = [
            ./configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.gabesaenz = import ./home.nix;
              # nixpkgs = {
              #   overlays = [
              #     darwin-emacs.overlays.emacs
              #   ];
              # };

              # Optionally, use home-manager.extraSpecialArgs to pass
              # arguments to home.nix
            }
          ];
        };
      };
    };
}
