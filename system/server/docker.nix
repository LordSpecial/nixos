{
  pkgs,
  ...
}:
{
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      "data-root" = "/home/server/docker";
      "log-driver" = "json-file";
      "log-opts" = {
        "max-file" = "3";
        "max-size" = "10m";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}
