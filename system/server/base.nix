{
  pkgs,
  ...
}:
{
  # Enable Flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Networking
  networking = {
    hostName = "specialserver";
    hostId = "2561dba1";
    useDHCP = false;
    interfaces.enp4s0.useDHCP = true;
    networkmanager.enable = true;
  };

  services.resolved.enable = true;
  networking.networkmanager.dns = "systemd-resolved";

  # Timezone and locale
  time.timeZone = "Australia/Sydney";
  i18n.defaultLocale = "en_AU.UTF-8";

  # ZFS
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.extraPools = [ "backup-tank" ];
  services.zfs.autoScrub = {
    enable = true;
    pools = [ "backup-tank" ];
  };

  # Media workloads need firmware and /dev/dri
  hardware = {
    enableRedistributableFirmware = true;
    graphics.enable = true;
  };

  # Fish shell
  programs.fish.enable = true;

  # Run dynamically linked non-Nix binaries
  programs.nix-ld.enable = true;

  # User identity parity for migration
  users.users.simon = {
    isNormalUser = true;
    uid = 1000;
    group = "users";
    description = "Simon A";
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "docker"
      "video"
      "render"
      "root"
    ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    gnumake
    tmux
    vim
    wget
    # AI Development Tools (latest versions via community flakes)
    claude-code # Latest Claude Code
    codex # Latest Codex CLI
  ];
}
