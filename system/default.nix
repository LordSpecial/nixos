let
  # Base laptop configuration
  laptop = [
    ./core
    ./secrets/agenix.nix
    ./secrets/git-credentials.nix
    ./secrets/ssh-keys.nix
  ];

  # Base server configuration
  server = [
    ./server
    ./secrets/agenix.nix
    ./secrets/git-credentials.nix
  ];
in
{
  inherit laptop;
  inherit server;
}
