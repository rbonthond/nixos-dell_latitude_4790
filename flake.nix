{
  description = "nixos config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = inputs @ { self, nixpkgs, home-manager, nixos-hardware }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        keep-derivations = true;
        keep-outputs = true;
        inputs-fonts.acceptLicense = true;
      };
    };
  in {
    nixosConfigurations = {
      "nixos" = nixpkgs.lib.nixosSystem {
        inherit system pkgs;
        modules = [
          nixos-hardware.nixosModules.dell-latitude-4790
          ./configuration.nix
        ]; 
      };
    };
    "robbin" = home-manager.lib.homeManagerConfiguration {
      inherit system pkgs;
      username = "robbin";
      homeDirectory = "/home/robbin";
      #config = import robbin.nix;
    };
  };

}
