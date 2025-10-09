{
  ...
}:
{
  wayland.windowManager.hyprland.settings = {
    general = {
      gaps_in = 5;
      gaps_out = 10;
      border_size = 2;
      "col.active_border" = "rgba(bc42f5ee) rgba(33ccffee) 45deg";
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
      "3, down, special"
    ];

    misc = {
      force_default_wallpaper = 0;
    };
  };
}
