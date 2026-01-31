{
  pkgs,
  ...
}:
{
  # Fish shell configuration
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # Initialize zoxide
      zoxide init fish | source

      # Initialize starship
      starship init fish | source
    '';
    shellAliases = {
      # Directory navigation
      ls = "eza --color=auto --group-directories-first";
      ll = "eza -l --color=auto --group-directories-first";
      la = "eza -la --color=auto --group-directories-first";
      tree = "eza --tree";
      cd = "z"; # Use zoxide instead of cd

      # File operations
      cat = "bat";
      less = "bat";
      more = "bat";

      # Search and find
      find = "fd";
      grep = "rg";

      # System monitoring
      ps = "procs";
      top = "btop";
      htop = "btop";

      # Network
      ping = "gping";

      # Disk usage
      du = "dust";
      df = "duf";

      # Quick utilities
      which = "which";
      history = "history";

      # Safety aliases (ask before destructive operations)
      rm = "rm -i";
      cp = "cp -i";
      mv = "mv -i";

      # Nix shortcuts
      rebuild = "make -C ~/.config/nixos switch";
      test-rebuild = "make -C ~/.config/nixos test";

      # Quick edit common files
      edit-config = "codium ~/.config/nixos/";
      edit-home = "set -l host (test -f ~/.config/nixos/.env; and awk -F= '/^HOST[[:space:]]*=/ {gsub(/[[:space:]]*/, \"\", $2); print $2; exit}' ~/.config/nixos/.env); if test -z \"$host\"; if set -q HOST; set host $HOST; else; set host workLaptop; end; end; codium ~/.config/nixos/home/profiles/$host.nix";
    };
  };

  # Starship prompt (same as before)
  programs.starship = {
    enable = true;
    settings = {
      format = "$all$character";
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
      };
      git_branch = {
        symbol = "🌱 ";
      };
      nix_shell = {
        symbol = "❄️ ";
      };
    };
  };

  # Zoxide (same as before)
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  # Foot terminal
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "JetBrains Mono:size=12, JetBrainsMono Nerd Font:size=12, Symbols Nerd Font:size=12";
        shell = "${pkgs.fish}/bin/fish";
        pad = "20x20";
      };
      colors = {
        alpha = 1.0;
        background = "000000";
      };
    };
  };

  # All the better CLI tools
  home.packages = with pkgs; [
    # File listing and navigation
    eza # Better ls
    zoxide # Better cd (smart jumping)

    # Text viewing and editing
    bat # Better cat (syntax highlighting)

    # Search and find
    fd # Better find
    ripgrep # Better grep
    fzf # Fuzzy finder

    # System monitoring
    btop # Better top/htop
    procs # Better ps

    # Network tools
    gping # Better ping with graphs

    # Disk utilities
    dust # Better du (disk usage)
    duf # Better df (disk free)

    # Additional utilities
    tree # Directory tree view
    tokei # Code statistics
    bandwhich # Network bandwidth usage
  ];

  # Set Fish as default shell
  home.sessionVariables = {
    SHELL = "${pkgs.fish}/bin/fish";
  };
}
