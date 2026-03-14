let
  workLaptop = "age1tztwvdu3hq0h8mea5h4spyp0drwlmas3tja4x036sulvqr4zcyvqdwmcag";
  server = "age1tztwvdu3hq0h8mea5h4spyp0drwlmas3tja4x036sulvqr4zcyvqdwmcag";
  stagingServer = "age18c8uemnrwpt246gly3ms9lwgadzj2an4rwpa5k58ptuzfrlqupjqqwmnj6";
in
{
  # Laptop secrets
  "secrets/aquila-office.nmconnection.age".publicKeys = [ workLaptop ];
  "secrets/Potentially-Safe-Network.nmconnection.age".publicKeys = [ workLaptop ];
  "secrets/git-credentials-lordspecial.age".publicKeys = [ workLaptop server stagingServer ];
  "secrets/git-credentials-aquilaspace.age".publicKeys = [ workLaptop server stagingServer ];
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
