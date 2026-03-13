{
  lib,
  pkgs,
  ...
}:
let
  hardwareConfig = ./. + "/hardware-configuration.nix";
in
{
  imports =
    lib.optional (builtins.pathExists hardwareConfig) hardwareConfig;

  warnings = lib.optional (!builtins.pathExists hardwareConfig) ''
    hosts/specialserver/hardware-configuration.nix is missing.
    Generate it on target during install with nixos-generate-config.
  '';

  # Bootloader - specific to this machine
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  environment.sessionVariables.COLORTERM = "truecolor";

  # Nix access token for private GitHub repos (e.g. aq-agent-config)
  nix.extraOptions = ''
    !include /run/nix/access-tokens.conf
  '';

  system.activationScripts.nixAccessTokens = {
    deps = [ "gitCredentials" ];
    text = ''
      ${pkgs.coreutils}/bin/install -d -m 0700 /run/nix

      token=""
      credentials_file="/home/simon/.config/git/credentials-aquilaspace"
      agenix_credentials_file="/run/agenix/git-credentials-aquilaspace"

      if [ -f "$credentials_file" ]; then
        token="$(${pkgs.gnused}/bin/sed -nE 's#^https?://[^:]*:([^@]+)@github.com.*#\1#p' "$credentials_file" | ${pkgs.coreutils}/bin/head -n 1)"
      elif [ -f "$agenix_credentials_file" ]; then
        token="$(${pkgs.gnused}/bin/sed -nE 's#^https?://[^:]*:([^@]+)@github.com.*#\1#p' "$agenix_credentials_file" | ${pkgs.coreutils}/bin/head -n 1)"
      fi

      if [ -n "$token" ]; then
        ${pkgs.coreutils}/bin/install -m 0400 /dev/null /run/nix/access-tokens.conf
        printf "access-tokens = github.com=%s\n" "$token" > /run/nix/access-tokens.conf
      else
        ${pkgs.coreutils}/bin/rm -f /run/nix/access-tokens.conf
      fi
    '';
  };

  system.stateVersion = "25.05";
}
