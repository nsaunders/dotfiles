{
  description = "System configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    alejandra = {
      url = "github:kamadorueda/alejandra/3.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    nixos-hardware,
    alejandra,
    ...
  }: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };

    overlay = final: prev: {
      inherit pkgs;
      alejandra = alejandra.defaultPackage.${system};
    };

    overlays = [overlay];

    hm-configuration-nick = {...}: {
      nixpkgs.overlays = overlays;
      imports = [./users/nick/home.nix];
    };
  in {
    homeConfigurations = {
      nick = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [hm-configuration-nick];
      };
    };

    nixosConfigurations = {
      sphx01w08 = nixpkgs.lib.nixosSystem {
        inherit system pkgs;

        modules = [
          {
            nixpkgs.overlays = overlays;
            system.stateVersion = "22.11";
          }
          nixos-hardware.nixosModules.lenovo-thinkpad-t480
          ./systems/sphx01w08/configuration.nix
        ];
      };
    };
  };
}
