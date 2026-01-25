{ inputs, ... }:
{
  # Core choices
  barChoice = "noctalia";
  animChoice = ../../modules/home/hyprland/animations-end4.nix;

  # Applications
  terminal = "kitty";
  browser = "brave";

  # Keyboard
  keyboardLayout = "us";
  keyboardVariant = "";

  # Monitor (set via hyprctl monitors if needed)
  extraMonitorSettings = ''
    monitor = eDP-1,2560x1600@240.0,0x0,1.0
  '';

  # Theming
  stylixImage = "${inputs.wallpapers}/apeiros/a_foggy_forest_with_trees.png";
}
