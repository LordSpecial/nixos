{ pkgs, ... }:
{
  boot.kernelModules = [ "wireguard" "nft_masq" "nft_chain_nat" ];

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  networking.wireguard.interfaces.wg0 = {
    ips = [ "10.8.0.1/24" ];
    listenPort = 51820;
    privateKeyFile = "/home/server/core/wireguard/privatekey";

    postSetup = ''
      ${pkgs.nftables}/bin/nft add table inet wg_nat
      ${pkgs.nftables}/bin/nft add chain inet wg_nat postrouting '{ type nat hook postrouting priority 100 ; }'
      ${pkgs.nftables}/bin/nft add rule inet wg_nat postrouting ip saddr 10.8.0.0/24 oifname enp4s0 masquerade
      ${pkgs.nftables}/bin/nft add chain inet wg_nat forward '{ type filter hook forward priority 0 ; }'
      ${pkgs.nftables}/bin/nft add rule inet wg_nat forward iifname wg0 accept
      ${pkgs.nftables}/bin/nft add rule inet wg_nat forward oifname wg0 accept
    '';

    postShutdown = ''
      ${pkgs.nftables}/bin/nft delete table inet wg_nat
    '';

    peers = [
      {
        # Simon's iPhone
        publicKey = "VaZqBRJlq7RQtQEjVzapo0qdoYqGJj9cPtqVTAj5Tl0=";
        allowedIPs = [ "10.8.0.2/32" ];
      }
      {
        # Android TV
        publicKey = "OqSJ5GhDUomMktUILW06kLixVUtUNZKr2eTNRg/lZDg=";
        allowedIPs = [ "10.8.0.3/32" ];
      }
      {
        # Simon's Laptop
        publicKey = "ui6AaBuQJgm2j9znoMGDcdcyTrwaoYGKavicwX1V4zs=";
        allowedIPs = [ "10.8.0.4/32" ];
      }
    ];
  };
}
