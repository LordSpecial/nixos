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

  home.file."AGENTS.md".source = ./files/AGENTS.md;

# Unfree packages are handled by system nixpkgs.config when using useGlobalPkgs

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
