{ pkgs, ... }:
{
  home.packages = [
    (import ./screenshootin.nix { inherit pkgs; })
    (import ./qs-keybinds.nix { inherit pkgs; })
  ];
}
