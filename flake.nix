{
  description = "System configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
  in {
    homeConfigurations = {
      nick = home-manager.lib.homeManagerConfiguration {
        modules = [ ./users/nick/home.nix ];
      };
    };

    nixosConfigurations = {
      sphx01w08 = nixpkgs.lib.nixosSystem {
        inherit system pkgs;

        modules = [
          { system.stateVersion = "22.11"; }
          ./systems/sphx01w08/configuration.nix
        ];
      };
    };
  };
}
