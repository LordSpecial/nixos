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
    ../../modules/home/hyprland
    ../../modules/home/dev-tools.nix
    ../../modules/home/dev-repos.nix
    ../../modules/home/noctalia.nix
    ../../modules/home/scripts
    ../../system/programs/vscodium.nix
    ../../system/programs/terminal.nix
  ];

  home.packages = with pkgs; [
    kitty
    spotify

    # Hyprland ecosystem packages
    fuzzel # App launcher
    dunst # Notifications
    swww # Wallpaper manager
    quickshell

    # Graphics Tools
    nvtopPackages.full
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

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

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
    GDK_BACKEND = "wayland";

    LIBVA_DRIVER_NAME = "iHD"; # For Intel hardware acceleration

    # For NVIDIA offloading (when using offload mode)
    __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };
}
