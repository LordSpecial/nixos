{ inputs, ... }:
{
  # Core choices
  barChoice = "noctalia";
  animChoice = ../../modules/home/hyprland/animations-end4.nix;

  # Applications
  terminal = "kitty";
  browser = "zen";

  # Keyboard
  keyboardLayout = "us";
  keyboardVariant = "";

  # Monitor (managed by nwg-displays -> ~/.config/hypr/monitors.conf)
  extraMonitorSettings = ''
    source=~/.config/hypr/monitors.conf
  '';

  # Theming
  stylixImage = "${inputs.wallpapers}/apeiros/a_foggy_forest_with_trees.png";
}
