{
  lib,
  ...
}:
let
  hardwareConfig = ./. + "/hardware-configuration.nix";
in
{
  imports =
    lib.optional (builtins.pathExists hardwareConfig) hardwareConfig;

  warnings = lib.optional (!builtins.pathExists hardwareConfig) ''
    hosts/stagingServer/hardware-configuration.nix is missing.
    Generate it on target during install with nixos-generate-config.
  '';

  # Bootloader - specific to this machine
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  # Override networking for this host
  networking = {
    hostName = lib.mkForce "stagingServer";
    hostId = lib.mkForce "a1b2c3d4";
    interfaces.enp4s0.useDHCP = lib.mkForce false; # disable specialserver's interface
    interfaces.enp1s0.useDHCP = true;
  };

  # Wifi support (not on specialserver)
  networking.wireless.iwd.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

  # Disable ZFS (no pool on this host yet)
  boot.supportedFilesystems = lib.mkForce [ ];
  boot.zfs.extraPools = lib.mkForce [ ];
  services.zfs.autoScrub.enable = lib.mkForce false;
  services.zfs.autoSnapshot.enable = lib.mkForce false;

  # Override server secrets — stagingServer can only decrypt git credentials
  age.secrets = lib.mkForce {
    git-credentials-lordspecial = {
      file = ../../secrets/git-credentials-lordspecial.age;
      owner = "simon";
      group = "users";
      mode = "0400";
    };
    git-credentials-aquilaspace = {
      file = ../../secrets/git-credentials-aquilaspace.age;
      owner = "simon";
      group = "users";
      mode = "0400";
    };
  };

  environment.sessionVariables.COLORTERM = "truecolor";

  # Nix access token for private GitHub repos (e.g. aq-agent-config)
  nix.extraOptions = ''
    !include /run/nix/access-tokens.conf
  '';

  system.stateVersion = "25.05";
}
