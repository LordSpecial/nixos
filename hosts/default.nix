{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations =
    let
      inherit (inputs.nixpkgs.lib) nixosSystem;

      # get these into the module system
      specialArgs = {
        inherit inputs self;
        zen-browser = inputs.zen-browser;
      };
    in
    {
      workLaptop = nixosSystem {
        inherit specialArgs;
        modules = [
          ./workLaptop/configuration.nix
          inputs.home-manager.nixosModules.home-manager
        ];
      };

      personalLaptop = nixosSystem {
        inherit specialArgs;
        modules = [
          ./personalLaptop/configuration.nix
          inputs.home-manager.nixosModules.home-manager
        ];
      };
    };
}