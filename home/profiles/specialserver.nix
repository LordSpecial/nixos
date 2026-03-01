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
  };
}
