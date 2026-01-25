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
          {
            home-manager = {
              users.simon.imports = [ ../home/profiles/workLaptop.nix ];
              extraSpecialArgs = specialArgs;
              backupFileExtension = ".hm-backup";
              useGlobalPkgs = true;
              useUserPackages = true;
            };
          }
        ];
      };

      personalLaptop = nixosSystem {
        inherit specialArgs;
        modules = [
          ./personalLaptop/configuration.nix
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              users.simon.imports = [ ../home/profiles/personalLaptop.nix ];
              extraSpecialArgs = specialArgs;
              backupFileExtension = ".hm-backup";
              useGlobalPkgs = true;
              useUserPackages = true;
            };
          }
        ];
      };
    };
}