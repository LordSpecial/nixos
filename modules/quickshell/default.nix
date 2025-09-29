{
  pkgs,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    qt6.qtimageformats
    qt6.qt5compat
    qt6.qtmultimedia
    qt6.qtdeclarative
    quickshell
    grim
    imagemagick
  ];

  qt.enable = true;

  xdg.configFile."quickshell/".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixos/modules/quickshell/shell";

  # Auto-start QuickShell
  systemd.user.services.quickshell = {
    Unit.Description = "QuickShell";
    Service = {
      ExecStart = "${pkgs.quickshell}/bin/quickshell";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
