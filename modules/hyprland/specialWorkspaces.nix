{ config, pkgs, ... }:

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

      # Configure special workspaces - auto-launch apps when created
      workspace = [
        "special:spotify, on-created-empty:spotify"
        "special:slack, on-created-empty:slack"
        "special:discord, on-created-empty:discord"
      ];

      # Keybindings to toggle special workspaces
      bind = [
        # Toggle Spotify scratchpad (SUPER + M)
        "SUPER, M, togglespecialworkspace, spotify"

        # Toggle Slack scratchpad (SUPER + SHIFT + S)
        "SUPER, S, togglespecialworkspace, slack"

        # Toggle Discord scratchpad (SUPER + SHIFT + D)
        "SUPER, D, togglespecialworkspace, discord"

        # Close current special workspace (SUPER alone or ESC)
        "SUPER, SUPER_L, togglespecialworkspace,"
        ", escape, togglespecialworkspace,"

        # Close special workspacesd
        "SUPER, 1, togglespecialworkspace," # Closes any open special workspace
        "SUPER, 2, togglespecialworkspace,"
        "SUPER, 3, togglespecialworkspace,"
        "SUPER, 4, togglespecialworkspace,"
        "SUPER, 5, togglespecialworkspace,"
        "SUPER, 6, togglespecialworkspace,"
        "SUPER, 7, togglespecialworkspace,"
        "SUPER, 8, togglespecialworkspace,"
        "SUPER, 9, togglespecialworkspace,"
        "SUPER, 0, togglespecialworkspace,"
        "SUPER_CTRL, right, togglespecialworkspace,"
        "SUPER_CTRL, left, togglespecialworkspace,"
      ];
    };
  };
}
