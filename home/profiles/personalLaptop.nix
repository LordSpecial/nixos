{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ../default.nix
    # Hyprland Config
    ../../system/programs/hyprland
    ../../system/programs/vscodium.nix
  ];

  home.packages = with pkgs; [
    kitty

    # Hyprland ecosystem packages
    fuzzel # App launcher
    dunst # Notifications
    swww # Wallpaper manager
    nwg-displays
    quickshell

    # Graphics Tools (commented out for personal laptop)
    #nvtopPackages.full
  ];

  # Git configuration with credential manager
  programs.git = {
    enable = true;
    userName = "Simon";
    userEmail = "simon@aquila.earth";

    extraConfig = {
      credential = {
        "https://github.com/LordSpecial" = {
          helper = "store --file=${config.home.homeDirectory}/.config/git/credentials-lordspecial";
        };
        "https://github.com/AquilaSpace" = {
          helper = "store --file=${config.home.homeDirectory}/.config/git/credentials-aquilaspace";
        };
      };
    };
  };

  home.pointerCursor = {
    name = "Qogir";
    package = pkgs.qogir-icon-theme;
    size = 24;
    gtk.enable = true;
    x11.enable = false;
  };

  wayland.windowManager.hyprland.settings.monitor = "eDP-1,preferred,auto,1.0";
  wayland.windowManager.hyprland.settings.bindl = lib.mkAfter [
    ",XF86MonBrightnessUp, exec, brightnessctl -d intel_backlight set +5%"
    ",XF86MonBrightnessDown, exec, brightnessctl -d intel_backlight set 5%-"
  ];

  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";

    # Firefox/Zen browser Wayland fixes
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_WEBRENDER = "1";
    MOZ_ACCELERATED = "1";

    # General Wayland app support
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
    GDK_BACKEND = "wayland";

    LIBVA_DRIVER_NAME = "iHD"; # For Intel hardware acceleration

  };
}
