{
  description = "Darwin configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # stylix.url = "github:danth/stylix";
    # stylix.inputs.nixpkgs.follows = "nixpkgs";
    # stylix.inputs.home-manager.follows = "home-manager";
  };

  # outputs = inputs@{ nixpkgs, home-manager, darwin, stylix, ... }: {
  outputs = inputs@{ nixpkgs, home-manager, darwin, ... }: {
    darwinConfigurations = {
      Gabe-Mac = darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        modules = [
          # stylix.darwinModules.stylix
          ./configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.gabesaenz = import ./home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };
    };
  };
}
