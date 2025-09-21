{ config, pkgs, lib, inputs, ... }:
{
  # Enable Hyprland in Home Manager
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    
    # Use extraConfig for more control, or settings for structured config
    settings = {
      monitor= "eDP-1,2560x1600@240.0,0x0,1.0";
      
      # Your keybindings
      bind = [

        "SUPER, C, exec, codium"
        "SUPER, SUPER_L, exec, pkill fuzzel || fuzzel"
        # Add some essential bindings that might be missing
        "SUPER, Q, killactive"
        "SUPER, W, exec, flatpak run app.zen_browser.zen"
        "SUPER, Return, exec, kitty"
        "SUPER, M, exit"
        "SUPER, E, exec, nautilus"
        "SUPER, V, togglefloating"
        "SUPER, P, pseudo"
        "SUPER, J, togglesplit"
        
        # Resize current window
        "SUPER, semicolon, resizeactive, -40 0"
        "SUPER, apostrophe, resizeactive, 40 0"
        "SUPER_SHIFT, semicolon, resizeactive, 0 -40"
        "SUPER_SHIFT, apostrophe, resizeactive, 0 40"
        "SUPER, F, fullscreen,"

        # Moving through existing workspaces
        "SUPER_CTRL, right, workspace, e+1"
        "SUPER_CTRL, left, workspace, e-1"
        "SUPER_CTRL_SHIFT, right, movetoworkspace, +1"
        "SUPER_CTRL_SHIFT, left, movetoworkspace, -1"

        # Move focus with mainMod + arrow keys, move window with shift
        "SUPER, left, movefocus, l"
        "SUPER, right, movefocus, r"
        "SUPER, up, movefocus, u"
        "SUPER, down, movefocus, d"
        "SUPER_SHIFT, left, swapwindow, l"
        "SUPER_SHIFT, right, swapwindow, r"
        "SUPER_SHIFT, up, swapwindow, u"
        "SUPER_SHIFT, down, swapwindow, d"
      ] ++ (
        # Workspace bindings
        builtins.concatLists (builtins.genList (i:
          let ws = i + 1;
          in [
            "SUPER, code:1${toString i}, workspace, ${toString ws}"
            "SUPER SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
          ]
        ) 9)
      );

      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
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

        # Requires playerctl
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];
      
      # Add some basic settings to ensure it works properly
      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
        allow_tearing = false;
      };

      input = {
        touchpad = {
          natural_scroll = true;
        };
      };
      
      gesture = [
        "3, horizontal, workspace"
      ];
      
      misc = {
        force_default_wallpaper = 0;
      };
    };
  };
}
