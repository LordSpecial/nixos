{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../default.nix
    ../../system/programs/terminal.nix
  ];

  # Git configuration
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Simon";
        email = "bcspace8@gmail.com";
      };
    };

    extraConfig = {
      credential = {
        "https://github.com/LordSpecial" = {
          helper = "store --file=${config.home.homeDirectory}/.config/git/credentials-lordspecial";
        };
        "https://github.com/AquilaSpace" = {
          helper = "store --file=${config.home.homeDirectory}/.config/git/credentials-aquilaspace";
        };
      };
    };
  };
}
