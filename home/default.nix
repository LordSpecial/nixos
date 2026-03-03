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

  home = {
    username = lib.mkDefault "simon";
    homeDirectory = lib.mkDefault "/home/simon";
    stateVersion = "25.05";
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
