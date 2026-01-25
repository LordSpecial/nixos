{
  host,
  inputs,
  ...
}: let
  vars = import ../../../hosts/${host}/variables.nix { inherit inputs; };
  inherit
    (vars)
    barChoice
    stylixImage
    ;
  # Noctalia-specific startup commands
  noctaliaExec =
    if barChoice == "noctalia"
    then [
      "killall -q waybar"
      "pkill waybar"
      "killall -q swaync"
      "pkill swaync"
      "noctalia-shell &"
    ]
    else [];
  # Waybar-specific startup commands
  waybarExec =
    if barChoice != "noctalia"
    then [
      "killall -q swww;sleep .5 && swww-daemon"
      "killall -q waybar;sleep .5 && waybar"
      "killall -q swaync;sleep .5 && swaync"
      "nm-applet --indicator"
      # Delayed-only restore so Stylix finishes first, then user's wallpaper wins with a single change
      "sh -lc 'sleep 2 && swww img ${stylixImage} >/dev/null 2>&1 || true'"
    ]
    else [];
in {
  wayland.windowManager.hyprland.settings = {
    exec-once =
      [
        "wl-paste --type text --watch cliphist store" # Saves text
        "wl-paste --type image --watch cliphist store" # Saves images
        "swww-daemon"
        "dbus-update-activation-environment --all --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "systemctl --user start hyprpolkitagent"
      ]
      ++ noctaliaExec ++ waybarExec;
  };
}
