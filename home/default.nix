{
  lib,
  ...
}:
{
  home = {
    username = lib.mkDefault "simon";
    homeDirectory = lib.mkDefault "/home/simon";
    stateVersion = "25.05";
  };

# Unfree packages are handled by system nixpkgs.config when using useGlobalPkgs

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}