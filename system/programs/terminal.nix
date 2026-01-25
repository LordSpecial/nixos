{
  config,
  pkgs,
  lib,
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
      rebuild = "sudo nixos-rebuild switch --flake ~/.config/nixos#workLaptop";
      test-rebuild = "sudo nixos-rebuild test --flake ~/.config/nixos#workLaptop";

      # Quick edit common files
      edit-config = "codium ~/.config/nixos/";
      edit-home = "codium ~/.config/nixos/hosts/workLaptop/home.nix";
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

  # Kitty terminal (same as before)
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrains Mono";
      size = 12;
    };
    settings = {
      # Window settings
      window_padding_width = 8;
      window_border_width = 0;

      # Tab settings
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";

      # Shell
      shell = "${pkgs.fish}/bin/fish";

      # Performance
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = "yes";
    };
    keybindings = {
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+q" = "close_tab";
      "ctrl+shift+right" = "next_tab";
      "ctrl+shift+left" = "previous_tab";
      "ctrl+shift+enter" = "new_window";
      "ctrl+shift+w" = "close_window";
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
