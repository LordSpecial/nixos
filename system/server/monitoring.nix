{
  # Tier 1 monitoring: Uptime Kuma, Beszel, ntfy

  # Uptime Kuma — service/endpoint monitoring
  services.uptime-kuma = {
    enable = true;
    settings = {
      PORT = "3001";
      HOST = "0.0.0.0";
    };
  };

  # Beszel — lightweight server resource monitoring
  # After first login to hub (:8090), add this server as a system.
  # Copy the generated SSH key into an environmentFile for the agent, then enable it.
  services.beszel = {
    agent = {
      enable = true;
      environment.KEY = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIzY7d2h2EEigKGsyTSZPEltOfFitYg7f9wq3YSb4My+";
    };
    hub = {
      enable = true;
      host = "0.0.0.0";
      port = 8090;
    };
  };

  # ntfy — push notification relay
  services.ntfy-sh = {
    enable = true;
    settings = {
      base-url = "http://localhost:2586";
      listen-http = ":2586";
    };
  };
}
