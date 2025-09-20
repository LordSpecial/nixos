{
  description = "I'm trying to make a config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    nix-flatpak.url = "github:gmodena/nix-flatpak";

  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      workLaptop = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/workLaptop/configuration.nix
          inputs.home-manager.nixosModules.home-manager
          inputs.nix-flatpak.nixosModules.nix-flatpak
        ];
      };
      personalLaptop = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/personalLaptop/configuration.nix
          inputs.home-manager.nixosModules.home-manager
          inputs.nix-flatpak.nixosModules.nix-flatpak
        ];
      };
    };
  };
}
