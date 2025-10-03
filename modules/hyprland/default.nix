{ ... }:
{
  imports = [
    ./hyprland.nix
    ./keybindings.nix
    ./appearance.nix
    ./specialWorkspaces.nix
  ];

  wayland.windowManager.hyprland.extraConfig = ''
    source = ~/.config/hypr/monitors.conf
  '';

}
