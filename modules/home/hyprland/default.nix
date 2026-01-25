{
  host,
  inputs,
  ...
}: let
  vars = import ../../../hosts/${host}/variables.nix { inherit inputs; };
  inherit (vars) animChoice;
in {
  imports = [
    animChoice
    ./binds.nix
    ./env.nix
    ./exec-once.nix
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./pyprland.nix
    ./windowrules.nix
  ];
}
