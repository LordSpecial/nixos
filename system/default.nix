let
  # Base laptop configuration
  laptop = [
    ./core
    ./secrets/agenix.nix
    ./secrets/git-credentials.nix
    # Note: SSH keys are imported per-host since they differ
  ];
in
{
  inherit laptop;
}
