{
  pkgs,
  host,
  inputs,
  ...
}: let
  vars = import ../../../hosts/${host}/variables.nix { inherit inputs; };
  inherit (vars) terminal;
in {
  home.packages = with pkgs; [pyprland];

  home.file.".config/hypr/pyprland.toml".text = ''
    [pyprland]
    plugins = [
      "scratchpads",
    ]

    [scratchpads.term]
    animation = "fromTop"
    command = "${terminal} --class kitty-dropterm"
    class = "kitty-dropterm"
    size = "70% 70%"
    max_size = "1920px 100%"
    position = "150px 150px"
  '';
}
