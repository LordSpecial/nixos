{
  # Server age identity (generate on server: sudo age-keygen -o /etc/age/shared.key)
  age.identityPaths = [ "/home/simon/.config/agenix/shared.key" ];

  # Container secrets — decrypted to /run/agenix/ at activation
  age.secrets = {
    gluetun-vpn-credentials = {
      file = ../../secrets/gluetun-vpn-credentials.age;
      owner = "root";
      mode = "0400";
    };
    cloudflared-tunnel-token = {
      file = ../../secrets/cloudflared-tunnel-token.age;
      owner = "root";
      mode = "0400";
    };
    code-server-password = {
      file = ../../secrets/code-server-password.age;
      owner = "simon";
      mode = "0400";
    };
    wikijs-db-password = {
      file = ../../secrets/wikijs-db-password.age;
      owner = "root";
      mode = "0400";
    };
    immich-db-password = {
      file = ../../secrets/immich-db-password.age;
      owner = "root";
      mode = "0400";
    };
    frigate-rtsp-password = {
      file = ../../secrets/frigate-rtsp-password.age;
      owner = "root";
      mode = "0400";
    };
    hardcover-api-token = {
      file = ../../secrets/hardcover-api-token.age;
      owner = "simon";
      mode = "0400";
    };
  };
}
