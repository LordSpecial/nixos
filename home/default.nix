{
  lib,
  inputs,
  ...
}:
{
  imports = [
    inputs.aq-agent-config.homeManagerModules.default
  ];

  programs.aqAgentConfig = {
    enable = true;
    source = inputs.aq-agent-config.outPath;
  };

  home.file.".config/nix/nix.conf".text = ''
    experimental-features = nix-command flakes
  '';

  home = {
    username = lib.mkDefault "simon";
    homeDirectory = lib.mkDefault "/home/simon";
    stateVersion = "25.05";
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
