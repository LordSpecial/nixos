{
  pkgs,
  inputs,
  ...
}:
{
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
  programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;

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

  # User
  users.users.simon = {
    isNormalUser = true;
    description = "Simon A";
    extraGroups = [
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
    xdg-utils
    polkit_gnome
    brightnessctl

    # AI Development Tools (latest versions via community flakes)
    claude-code  # Latest Claude Code
    codex        # Latest Codex CLI

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
