{
  pkgs,
  inputs,
  zen-browser,
  ...
}:
let
  vars = import ./variables.nix { inherit inputs; };
in
{
  imports = [
    ./hardware-configuration.nix

    # Graphics Stuff - Intel-only setup
    ../../system/hardware/intel-gpu.nix

    # SSH keys for personal laptop
    ../../system/secrets/ssh-keys-personal.nix
  ];

  # Bootloader - specific to this machine
  boot = {
    loader.grub = {
      efiSupport = true;
      device = "nodev";
      useOSProber = true;
    };
    loader.systemd-boot.enable = false;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking.hostName = "nixos-personal";
  services.resolved.enable = true;
  networking.networkmanager.dns = "systemd-resolved";

  # Cloudflare WARP (optional - remove if not needed)
  services.cloudflare-warp.enable = true;

  # Tailscale VPN (optional - remove if not needed)
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "none";
    extraUpFlags = [
      "--accept-dns=true"
      "--accept-routes=false"
    ];
  };
  networking.firewall.checkReversePath = "loose";
  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  age.identityPaths = [ "/home/simon/.config/agenix/shared.key" ];

  nix.extraOptions = ''
    !include /run/nix/access-tokens.conf
  '';

  system.activationScripts.nixAccessTokens = {
    deps = [ "gitCredentials" ];
    text = ''
      credentials_file="/home/simon/.config/git/credentials-aquilaspace"
      agenix_credentials_file="/run/agenix/git-credentials-aquilaspace"
      tokens_file="/run/nix/access-tokens.conf"

      ${pkgs.coreutils}/bin/install -d -m 0700 /run/nix

      token=""
      if [ -f "$credentials_file" ]; then
        token="$(${pkgs.gnused}/bin/sed -nE 's#^https?://[^:]*:([^@]+)@github.com.*#\1#p' "$credentials_file" | ${pkgs.coreutils}/bin/head -n 1)"
      elif [ -f "$agenix_credentials_file" ]; then
        token="$(${pkgs.gnused}/bin/sed -nE 's#^https?://[^:]*:([^@]+)@github.com.*#\1#p' "$agenix_credentials_file" | ${pkgs.coreutils}/bin/head -n 1)"
      fi

      if [ -n "$token" ]; then
        ${pkgs.coreutils}/bin/install -m 0400 -o simon -g users /dev/null "$tokens_file"
        printf "access-tokens = github.com=%s\n" "$token" > "$tokens_file"
      else
        ${pkgs.coreutils}/bin/rm -f "$tokens_file"
      fi
    '';
  };

  # Configure Graphics - Intel-only setup
  system.intel.enable = true;

  # Personal-specific packages
  environment.systemPackages = with pkgs; [
    zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    pciutils # For GPU detection
    mesa-demos # For OpenGL testing
    vulkan-tools # For Vulkan support
    nwg-displays
    thunar
    obs-studio
    gimp
    pavucontrol
    playerctl
    swaynotificationcenter
    tailscale
  ];

  system.stateVersion = "25.05";
}
