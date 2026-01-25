# SDDM is a display manager for X11 and Wayland
{
  pkgs,
  config,
  lib,
  ...
}: let
  stylix = if config ? stylix then config.stylix else null;
  stylixImage = if stylix != null then toString stylix.image else null;
  foreground = if stylix != null then stylix.base16Scheme.base00 else "0c0c0c";
  textColor = if stylix != null then stylix.base16Scheme.base05 else "f2f2f2";
  sddm-astronaut =
    if stylix == null
    then pkgs.sddm-astronaut
    else pkgs.sddm-astronaut.override {
      embeddedTheme = "pixel_sakura";
      themeConfig =
        if lib.hasSuffix "sakura_static.png" stylixImage
        then {
          FormPosition = "left";
          Blur = "2.0";
          HourFormat = "h:mm AP";
        }
        else if lib.hasSuffix "studio.png" stylixImage
        then {
          Background = pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/anotherhadi/nixy-wallpapers/refs/heads/main/wallpapers/studio.gif";
            sha256 = "sha256-qySDskjmFYt+ncslpbz0BfXiWm4hmFf5GPWF2NlTVB8=";
          };
          HourFormat = "h:mm AP";
          HeaderTextColor = "#${textColor}";
          DateTextColor = "#${textColor}";
          TimeTextColor = "#${textColor}";
          LoginFieldTextColor = "#${textColor}";
          PasswordFieldTextColor = "#${textColor}";
          UserIconColor = "#${textColor}";
          PasswordIconColor = "#${textColor}";
          WarningColor = "#${textColor}";
          LoginButtonBackgroundColor = "#${foreground}";
          SystemButtonsIconsColor = "#${foreground}";
          SessionButtonTextColor = "#${textColor}";
          VirtualKeyboardButtonTextColor = "#${textColor}";
          DropdownBackgroundColor = "#${foreground}";
          HighlightBackgroundColor = "#${textColor}";
        }
        else {
          FormPosition = "left";
          Blur = "4.0";
          Background = stylixImage;
          HourFormat = "h:mm AP";
          HeaderTextColor = "#${textColor}";
          DateTextColor = "#${textColor}";
          TimeTextColor = "#${textColor}";
          LoginFieldTextColor = "#${textColor}";
          PasswordFieldTextColor = "#${textColor}";
          UserIconColor = "#${textColor}";
          PasswordIconColor = "#${textColor}";
          WarningColor = "#${textColor}";
          LoginButtonBackgroundColor = "#${stylix.base16Scheme.base01}";
          SystemButtonsIconsColor = "#${textColor}";
          SessionButtonTextColor = "#${textColor}";
          VirtualKeyboardButtonTextColor = "#${textColor}";
          DropdownBackgroundColor = "#${stylix.base16Scheme.base01}";
          HighlightBackgroundColor = "#${textColor}";
          FormBackgroundColor = "#${stylix.base16Scheme.base01}";
        };
    };
in {
  services.displayManager = {
    sddm = {
      package = pkgs.kdePackages.sddm;
      extraPackages = [sddm-astronaut];
      enable = true;
      wayland.enable = true;
      theme = "sddm-astronaut-theme";
      settings = let
        keyboardLayout = config.services.xserver.xkb.layout or "us";
        keyboardVariant = config.services.xserver.xkb.variant or "";
      in {
        X11 = {
          XkbLayout = keyboardLayout;
          XkbVariant = keyboardVariant;
        };
      };
    };
  };

  # Ensure Wayland SDDM also sees XKB defaults
  systemd.services.display-manager.environment = let
    keyboardLayout = config.services.xserver.xkb.layout or "us";
    keyboardVariant = config.services.xserver.xkb.variant or "";
  in ({XKB_DEFAULT_LAYOUT = keyboardLayout;}
    // lib.optionalAttrs (keyboardVariant != "") {XKB_DEFAULT_VARIANT = keyboardVariant;});

  environment.systemPackages = [sddm-astronaut];
}
