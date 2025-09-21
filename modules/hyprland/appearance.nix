{ config, pkgs, lib, ... }:
{
  wayland.windowManager.hyprland.settings = {
    monitor = "eDP-1,2560x1600@240.0,0x0,1.0";

    general = {
      gaps_in = 5;
      gaps_out = 10;
      border_size = 2;
      "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
      "col.inactive_border" = "rgba(595959aa)";
      layout = "dwindle";
      allow_tearing = false;
    };

    decoration = {
      rounding = 10;
      rounding_power = 2;
    };

    input = {
      touchpad = {
        natural_scroll = true;
      };
    };

    gesture = [
      "3, horizontal, workspace"
    ];

    misc = {
      force_default_wallpaper = 0;
    };
  };
}