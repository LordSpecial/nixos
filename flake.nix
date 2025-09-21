{
  description = "I'm trying to make a config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    zen-browser.url = "github:youwen5/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      zen-browser,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        workLaptop = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            zen-browser = zen-browser;
          };
          modules = [
            ./hosts/workLaptop/configuration.nix
            inputs.home-manager.nixosModules.home-manager
          ];
        };
        personalLaptop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/personalLaptop/configuration.nix
            inputs.home-manager.nixosModules.home-manager
          ];
        };
      };
    };
}
