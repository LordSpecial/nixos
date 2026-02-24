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

    # Graphics Stuff - Hybrid Intel/NVIDIA setup
    ../../system/hardware/intel-gpu.nix
    ../../system/hardware/nvidia-gpu.nix
    ../../system/hardware/hybrid-nv-in-gpu.nix
  ];

  # Bootloader - specific to this machine
  boot = {
    loader.grub = {
      device = "/dev/nvme0n1";
      useOSProber = false;
      extraEntries = ''
        menuentry "Arch Linux (Fixed)" {
          set root='hd0,msdos1'
          linux /vmlinuz-linux root=/dev/nvme0n1p3 rw
          initrd /initramfs-linux.img
        }
      '';
    };
    loader.systemd-boot.enable = false;
    loader.efi.canTouchEfiVariables = false;
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking.hostName = "nixos";
  services.resolved.enable = true;
  networking.networkmanager.dns = "systemd-resolved";

  # Cloudflare WARP
  services.cloudflare-warp.enable = true;

  # Tailscale VPN
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

  age.identityPaths = [ "/home/simon/.config/agenix/ageWorkLaptop.key" ];

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

  # Configure Graphics - specific to this hybrid setup
  system.hybrid.enable = true;

  # Work-specific packages
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
