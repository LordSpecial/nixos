{
  ...
}:
{
  wayland.windowManager.hyprland.settings = {
    bind = [
      # Bindings
      "SUPER, C, exec, codium"
      "SUPER, SUPER_L, exec, pkill fuzzel || fuzzel"
      "SUPER, Q, killactive"
      "SUPER, W, exec, zen"
      "SUPER, Return, exec, kitty"
      "SUPER, E, exec, nautilus"
      "SUPER, V, togglefloating"

      # Window Management
      "SUPER, semicolon, resizeactive, -40 0"
      "SUPER, apostrophe, resizeactive, 40 0"
      "SUPER_SHIFT, semicolon, resizeactive, 0 -40"
      "SUPER_SHIFT, apostrophe, resizeactive, 0 40"
      "SUPER, F, fullscreen,"

      # Move around the workspaces
      "SUPER_CTRL, right, workspace, e+1"
      "SUPER_CTRL, left, workspace, e-1"
      "SUPER_CTRL_SHIFT, right, movetoworkspace, +1"
      "SUPER_CTRL_SHIFT, left, movetoworkspace, -1"
      "SUPER_SHIFT, left, swapwindow, l"
      "SUPER_SHIFT, right, swapwindow, r"
      "SUPER_SHIFT, up, swapwindow, u"
      "SUPER_SHIFT, down, swapwindow, d"

      # Shuft focus
      "SUPER, left, movefocus, l"
      "SUPER, right, movefocus, r"
      "SUPER, up, movefocus, u"
      "SUPER, down, movefocus, d"
    ]
    ++ (
      # Workspace bindings
      builtins.concatLists (
        builtins.genList (
          i:
          let
            ws = i + 1;
          in
          [
            "SUPER, code:1${toString i}, workspace, ${toString ws}"
            "SUPER SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
          ]
        ) 9
      )
    );

    bindm = [
      "SUPER, mouse:272, movewindow"
      "SUPER, mouse:273, resizewindow"
    ];

    bindl = [
      ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
      ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ",XF86MonBrightnessUp, exec, brightnessctl -d intel_backlight set +5%"
      ",XF86MonBrightnessDown, exec, brightnessctl -d intel_backlight set 5%-"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPause, exec, playerctl play-pause"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
    ];
  };
}
