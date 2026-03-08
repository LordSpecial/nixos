let
  workLaptop = "age1tztwvdu3hq0h8mea5h4spyp0drwlmas3tja4x036sulvqr4zcyvqdwmcag";
  server = "age1tztwvdu3hq0h8mea5h4spyp0drwlmas3tja4x036sulvqr4zcyvqdwmcag";
in
{
  # Laptop secrets
  "secrets/aquila-office.nmconnection.age".publicKeys = [ workLaptop ];
  "secrets/Potentially-Safe-Network.nmconnection.age".publicKeys = [ workLaptop ];
  "secrets/git-credentials-lordspecial.age".publicKeys = [ workLaptop ];
  "secrets/git-credentials-aquilaspace.age".publicKeys = [ workLaptop ];
  "secrets/work-laptop-ssh-key.age".publicKeys = [ workLaptop ];

  # Server secrets
  "secrets/gluetun-vpn-credentials.age".publicKeys = [ server ];
  "secrets/cloudflared-tunnel-token.age".publicKeys = [ server ];
  "secrets/code-server-password.age".publicKeys = [ server ];
  "secrets/wikijs-db-password.age".publicKeys = [ server ];
  "secrets/immich-db-password.age".publicKeys = [ server ];
  "secrets/frigate-rtsp-password.age".publicKeys = [ server ];
  "secrets/hardcover-api-token.age".publicKeys = [ server ];
}
