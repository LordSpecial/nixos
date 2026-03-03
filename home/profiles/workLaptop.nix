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
    foot
    spotify

    # Graphics Tools
    nvtopPackages.full
  ];

  # Git configuration with credential manager
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Simon";
        email = "simon@aquila.earth";
      };
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

  # SSH default identity
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [ "~/.ssh/config.local" ];
    matchBlocks."*" = {
      identityFile = [ "~/.ssh/work_laptop_id_ed25519" ];
      identitiesOnly = true;
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
    # Firefox/Zen browser Wayland fixes
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_WEBRENDER = "1";
    MOZ_ACCELERATED = "1";

    # General Wayland app support
    NIXOS_OZONE_WL = "1";
    GDK_BACKEND = "wayland";
    QT_QPA_PLATFORM = "wayland";

    LIBVA_DRIVER_NAME = "iHD"; # For Intel hardware acceleration

    # For NVIDIA offloading (when using offload mode)
    __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };
}
