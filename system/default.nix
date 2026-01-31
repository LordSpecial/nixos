let
  # Base laptop configuration
  laptop = [
    ./core
    ./secrets/agenix.nix
    ./secrets/git-credentials.nix
    ./secrets/ssh-keys.nix
  ];
in
{
  inherit laptop;
}
