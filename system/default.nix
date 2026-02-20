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
  ];
in
{
  inherit laptop;
  inherit server;
}
