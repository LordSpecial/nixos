{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations =
    let
      inherit (inputs.nixpkgs.lib) nixosSystem;

      # get the basic config to build on top of
      inherit (import "${self}/system") laptop server;

      # get these into the module system
      specialArgs = {
        inherit inputs self;
        zen-browser = inputs.zen-browser;
      };
    in
    {
      workLaptop = nixosSystem {
        inherit specialArgs;
        modules = laptop ++ [
          ./workLaptop
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              users.simon.imports = [ ../home/profiles/workLaptop.nix ];
              extraSpecialArgs = specialArgs // {
                host = "workLaptop";
              };
              backupFileExtension = ".hm-backup";
              useGlobalPkgs = true;
              useUserPackages = true;
            };
          }
        ];
      };

      personalLaptop = nixosSystem {
        inherit specialArgs;
        modules = laptop ++ [
          ./personalLaptop
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              users.simon.imports = [ ../home/profiles/personalLaptop.nix ];
              extraSpecialArgs = specialArgs // {
                host = "personalLaptop";
              };
              backupFileExtension = ".hm-backup";
              useGlobalPkgs = true;
              useUserPackages = true;
            };
          }
        ];
      };

      specialserver = nixosSystem {
        inherit specialArgs;
        modules = server ++ [
          ./specialserver
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              users.simon.imports = [ ../home/profiles/specialserver.nix ];
              extraSpecialArgs = specialArgs // {
                host = "specialserver";
              };
              backupFileExtension = ".hm-backup";
              useGlobalPkgs = true;
              useUserPackages = true;
            };
          }
        ];
      };
    };
}
