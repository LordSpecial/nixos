{ config, lib, ... }:
with lib;
let
  cfg = config.system.hybrid;
in
{
  options.system.hybrid = {
    enable = mkEnableOption "hybrid graphics";
    intelBusId = mkOption {
      type = types.str;
      default = "PCI:0:2:0";
    };
    nvidiaBusId = mkOption {
      type = types.str;
      default = "PCI:1:0:0";
    };
    mode = mkOption {
      type = types.enum [
        "offload"
        "sync"
      ];
      default = "offload";
    };
  };

  config = mkIf cfg.enable {
    # Ensure both are enabled
    system.intel.enable = mkDefault true;
    system.nvidia.enable = mkDefault true;

    hardware.nvidia.prime = {
      intelBusId = cfg.intelBusId;
      nvidiaBusId = cfg.nvidiaBusId;
      sync.enable = cfg.mode == "sync";
      offload = mkIf (cfg.mode == "offload") {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };
}
