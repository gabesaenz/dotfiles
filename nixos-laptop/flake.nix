{
  # 25.05
  # inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-25.05;
  # unstable
  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
  outputs = { self, nixpkgs }: {
    # hostname:
    # nixosConfigurations.<hostname> = ...
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      modules = [ ./configuration.nix ];
    };
  };
}
