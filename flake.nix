{
  description = "Darwin configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-24.11-darwin";
    darwin.url = "github:lnl7/nix-darwin/nix-darwin-24.11";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # automatically manage mac application links
    mac-app-util.url = "github:hraban/mac-app-util";

    # manage doom emacs through nix
    nix-doom-emacs-unstraightened.url = "github:marienz/nix-doom-emacs-unstraightened";
    # Optional, to download less. Neither the module nor the overlay uses this input.
    nix-doom-emacs-unstraightened.inputs.nixpkgs.follows = "";
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      darwin,
      mac-app-util,
      ...
    }:
    {
      darwinConfigurations = {
        Gabe-Mac = darwin.lib.darwinSystem {
          system = "x86_64-darwin";
          modules = [
            {
              nixpkgs.overlays = [
                (self: super: {
                  # avoid build break in nodejs-20.19 on darwin
                  nodejs = super.nodejs_22;
                })
                inputs.nix-doom-emacs-unstraightened.overlays.default
              ];
            }
            mac-app-util.darwinModules.default
            ./configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.gabesaenz = import ./home.nix;

              # Optionally, use home-manager.extraSpecialArgs to pass
              # arguments to home.nix

              home-manager.sharedModules = [
                inputs.nix-doom-emacs-unstraightened.homeModule
                mac-app-util.homeManagerModules.default
              ];
            }
          ];
          # access inputs from configuration.nix (doom-emacs overlay)
          specialArgs = { inherit inputs; };
        };
      };
    };
}
