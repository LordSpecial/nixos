{
  imports = [
    ./base.nix
    ./docker.nix
    ./smb.nix
    ./ssh.nix
    ./firewall.nix
    ./monitoring.nix
    ./wireguard.nix

    ./secrets.nix
  ];
}
