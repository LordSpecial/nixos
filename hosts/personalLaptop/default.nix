{
  pkgs,
  inputs,
  zen-browser,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix

    # Graphics Stuff - Intel-only setup
    ../../system/hardware/intel-gpu.nix
  ];

  # Bootloader - specific to this machine
  boot = {
    loader.grub = {
      efiSupport = true;
      device = "nodev";
      useOSProber = true;
    };
    loader.systemd-boot.enable = false;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking.hostName = "nixos-personal";

  # Configure Graphics - Intel-only setup
  system.intel.enable = true;

  # Personal-specific packages
  environment.systemPackages = with pkgs; [
    zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  system.stateVersion = "25.05";
}
