{ ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # Window rules to assign apps to special workspaces
      windowrulev2 = [
        # Spotify - move to special workspace
        "workspace special:spotify silent, class:^(Spotify)$"
        "workspace special:spotify silent, title:^(Spotify)$"
        # Slack - move to special workspace
        "workspace special:slack silent, class:^(Slack)$"
        "workspace special:slack silent, title:^(Slack)$"
        # Discord - move to special workspace
        "workspace special:discord silent, class:^(discord)$"
        "workspace special:discord silent, class:^(Discord)$"
      ];

      # Keybindings to toggle special workspaces
      bind = [
        # Toggle Spotify scratchpad (SUPER + M)
        "SUPER, M, togglespecialworkspace, spotify"
        # Toggle Slack scratchpad (SUPER + S)
        "SUPER, S, togglespecialworkspace, slack"
        # Toggle Discord scratchpad (SUPER + D)
        "SUPER, D, togglespecialworkspace, discord"

        # Close any open special workspace (ESC)
        "SUPER, escape, exec, hyprctl dispatch togglespecialworkspace __TEMP; hyprctl dispatch togglespecialworkspace __TEMP"

        # Close special workspaces when switching workspaces
        "SUPER, 1, exec, hyprctl dispatch togglespecialworkspace __TEMP; hyprctl dispatch togglespecialworkspace __TEMP"
        "SUPER, 2, exec, hyprctl dispatch togglespecialworkspace __TEMP; hyprctl dispatch togglespecialworkspace __TEMP"
        "SUPER, 3, exec, hyprctl dispatch togglespecialworkspace __TEMP; hyprctl dispatch togglespecialworkspace __TEMP"
        "SUPER, 4, exec, hyprctl dispatch togglespecialworkspace __TEMP; hyprctl dispatch togglespecialworkspace __TEMP"
        "SUPER, 5, exec, hyprctl dispatch togglespecialworkspace __TEMP; hyprctl dispatch togglespecialworkspace __TEMP"
        "SUPER, 6, exec, hyprctl dispatch togglespecialworkspace __TEMP; hyprctl dispatch togglespecialworkspace __TEMP"
        "SUPER, 7, exec, hyprctl dispatch togglespecialworkspace __TEMP; hyprctl dispatch togglespecialworkspace __TEMP"
        "SUPER, 8, exec, hyprctl dispatch togglespecialworkspace __TEMP; hyprctl dispatch togglespecialworkspace __TEMP"
        "SUPER, 9, exec, hyprctl dispatch togglespecialworkspace __TEMP; hyprctl dispatch togglespecialworkspace __TEMP"
        "SUPER, 0, exec, hyprctl dispatch togglespecialworkspace __TEMP; hyprctl dispatch togglespecialworkspace __TEMP"
        "SUPER_CTRL, right, exec, hyprctl dispatch togglespecialworkspace __TEMP; hyprctl dispatch togglespecialworkspace __TEMP"
        "SUPER_CTRL, left, exec, hyprctl dispatch togglespecialworkspace __TEMP; hyprctl dispatch togglespecialworkspace __TEMP"
      ];
    };
  };
}
