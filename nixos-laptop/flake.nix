{
  # 26.05
  # inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-26.05;
  # unstable
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { self, nixpkgs, ... }@inputs:
    {
      # hostname:
      # nixosConfigurations.<hostname> = ...
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        ### Tip: https://nixos.wiki/wiki/Flakes#Using_nix_flakes_with_NixOS
        ### Set specialArgs to inherit inputs if your configuration.nix module imports other *.nix configuration files.
        specialArgs = { inherit inputs; };

        modules = [ ./configuration.nix ];
      };
    };
}
