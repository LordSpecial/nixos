{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    fuzzel
  ];

  xdg.configFile."fuzzel/fuzzel.ini".text = ''
    include="~/.config/fuzzel/fuzzel_theme.ini"
    [main]
      terminal=kitty -1
      prompt="  "
      layer=overlay

    [border]
      radius=17
      width=1

    [dmenu]
      exit-immediately-if-empty=yes

    [colors]
      background=161217ff
      text=e9e0e8ff
      selection=4b454dff
      selection-text=cdc3ceff
      border=4b454ddd
      match=dfb8f6ff
      selection-match=dfb8f6ff
  '';

}
