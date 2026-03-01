{
  pkgs,
  ...
}:
{
  # Foot terminal
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "JetBrains Mono:size=12, JetBrainsMono Nerd Font:size=12, Symbols Nerd Font:size=12";
        shell = "${pkgs.fish}/bin/fish";
        pad = "20x20";
      };
      colors = {
        alpha = 1.0;
        background = "000000";
      };
    };
  };
}
