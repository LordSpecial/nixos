let
  # Base laptop configuration
  laptop = [
    ./core
    ./secrets/agenix.nix
    ./secrets/git-credentials.nix
  ];
in
{
  inherit laptop;
}
