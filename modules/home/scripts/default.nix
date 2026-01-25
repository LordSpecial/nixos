{ pkgs, ... }:
{
  home.packages = [
    (import ./screenshootin.nix { inherit pkgs; })
  ];
}
