{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./sddm.nix
  ];

  # Enable Flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Networking
  networking.networkmanager.enable = true;

  # Timezone and locale
  time.timeZone = "Australia/Sydney";
  i18n.defaultLocale = "en_AU.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  # Desktop Environment
  services.displayManager.gdm.enable = false;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.gnome.enable = true;

  # Hyprland
  programs.hyprland.enable = true;
  programs.hyprland.package = inputs.hyprland.packages."${pkgs.stdenv.hostPlatform.system}".hyprland;

  # X11 keymap
  services.xserver.xkb = {
    layout = "au";
    variant = "";
  };

  # Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Printing
  services.printing.enable = true;

  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Input
  services.libinput.enable = true;

  # Security
  security.sudo.wheelNeedsPassword = true;
  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=240
    Defaults timestamp_type=global
  '';
  services.udev.extraRules = ''
    # ST-Link USB adapters (allow access for active user)
    SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="3748", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="374b", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="374f", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="3752", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="3753", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="3754", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="3757", TAG+="uaccess"

    # Fallback for non-seat sessions (grant dialout group access)
    SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="3754", MODE="0660", GROUP="dialout"
    KERNEL=="hidraw*", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3754", MODE="0660", GROUP="dialout"
  '';

  # User
  users.users.simon = {
    isNormalUser = true;
    description = "Simon A";
    extraGroups = [
      "dialout"
      "networkmanager"
      "wheel"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Add overlays for latest AI tools
  nixpkgs.overlays = [
    inputs.claude-code.overlays.default
    inputs.codex-cli.overlays.default
  ];

  # Base system packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    slack
    vscodium
    discord
    gnumake
    firefox
    gitkraken
    xdg-utils
    polkit_gnome
    brightnessctl
    age

    # AI Development Tools (latest versions via community flakes)
    claude-code # Latest Claude Code
    codex # Latest Codex CLI

    # Hyprland + Noctalia essentials
    cliphist
    grim
    hyprpicker
    hyprpolkitagent
    hyprshot
    matugen
    pyprland
    swww
    swappy
    wl-clipboard
    slurp
    gpu-screen-recorder
  ];

  # Fonts
  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];

  # Power and battery services (Noctalia needs these)
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  # XDG portal
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
    config.common.default = "gtk";
  };
}
