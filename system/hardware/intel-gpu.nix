{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.system.intel;
in
{
  options.system.intel = {
    enable = mkEnableOption "Intel graphics";
    useNewDriver = mkOption {
      type = types.bool;
      default = true;
      description = "Use intel-media-driver for newer GPUs";
    };
  };

  config = mkIf cfg.enable {
    hardware.graphics.extraPackages = with pkgs; [
      (if cfg.useNewDriver then intel-media-driver else intel-vaapi-driver)
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };
}
