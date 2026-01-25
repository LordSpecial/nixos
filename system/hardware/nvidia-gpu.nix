{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.system.nvidia;
in
{
  options.system.nvidia = {
    enable = mkEnableOption "NVIDIA graphics";
    openSource = mkOption {
      type = types.bool;
      default = false;
    };
    powerManagement.enable = mkOption {
      type = types.bool;
      default = false;
    };
    busId = mkOption {
      type = types.str;
      default = "PCI:1:0:0";
    };
  };

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = cfg.powerManagement.enable;
      open = cfg.openSource;
      nvidiaSettings = true;
    };
  };
}
