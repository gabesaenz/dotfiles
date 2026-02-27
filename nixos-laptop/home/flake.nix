{
  description = "Home Manager configuration of gabe";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    # 25.05
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    # unstable
    nixpkgs.url = "github:nixos/nixpkgs";
    home-manager = {
      # 25.05
      # url = "github:nix-community/home-manager/release-25.05";
      # unstable
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-doom-emacs-unstraightened.url = "github:marienz/nix-doom-emacs-unstraightened";
    # Optional, to download less. Neither the module nor the overlay uses this input.
    nix-doom-emacs-unstraightened.inputs.nixpkgs.follows = "";
    plover-flake.url = "github:openstenoproject/plover-flake";
  };

  outputs =
    inputs@{ nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations."gabe" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          inputs.nix-doom-emacs-unstraightened.homeModule
          ./home.nix
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        # required by doom-emacs-unstraightened
        extraSpecialArgs = { inherit inputs; };
      };
    };
}
