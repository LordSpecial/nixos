{
  lib,
  pkgs,
  ...
}:
let
  hardwareConfig = ./. + "/hardware-configuration.nix";
in
{
  imports =
    lib.optional (builtins.pathExists hardwareConfig) hardwareConfig;

  warnings = lib.optional (!builtins.pathExists hardwareConfig) ''
    hosts/specialserver/hardware-configuration.nix is missing.
    Generate it on target during install with nixos-generate-config.
  '';

  # Bootloader - specific to this machine
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
  };

  system.stateVersion = "25.05";
}
