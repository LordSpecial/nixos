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

  age.identityPaths = [ "/home/simon/.config/agenix/ageWorkLaptop.key" ];

  # Configure Graphics - specific to this hybrid setup
  system.hybrid.enable = true;

  # Work-specific packages
  environment.systemPackages = with pkgs; [
    zen-browser.packages.${pkgs.system}.default
    pciutils # For GPU detection
    glxinfo # For OpenGL testing
    vulkan-tools # For Vulkan support
    nwg-displays
    xfce.thunar
    obs-studio
    gimp
    pavucontrol
    playerctl
    swaynotificationcenter
  ];

  system.stateVersion = "25.05";
}
