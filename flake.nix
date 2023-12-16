{
  description = "nixos config";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    nixos-hardware,
  }: {
    nixosConfigurations = {
      "nixos" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./configuration.nix
          nixos-hardware.nixosModules.dell-latitude-7490
        ];
      };
    };
  };
}
