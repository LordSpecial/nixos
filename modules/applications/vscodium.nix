{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    profiles.default = {
      extensions =
        with pkgs.vscode-extensions;
        [
          # Language support
          llvm-vs-code-extensions.vscode-clangd
          ms-python.python

          # Productivity
          ms-vscode.hexeditor

          # Remote development
          ms-vscode-remote.remote-ssh

        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          # Extensions not in nixpkgs yet
          {
            name = "nix-ide";
            publisher = "jnoortheen";
            version = "0.4.23";
            sha256 = "sha256-MnuFMrP52CcWZTyf2OKSqQ/oqCS3PPivwEIja25N2D0=";
          }
          {
            name = "mayukaithemevsc";
            publisher = "gulajavaministudio";
            version = "3.2.4"; # You'll need to find the correct version
            sha256 = "sha256-V2hAxIVu2YWonwcIG+9n300b88jzPOnKYUFt1okSX4w="; # You'll need to get the hash
          }
        ];

      userSettings = {
        # Editor settings
        "editor.fontFamily" = "JetBrains Mono, 'Droid Sans Mono', 'monospace'";
        "editor.fontSize" = 14;
        "editor.lineHeight" = 1.5;
        "editor.tabSize" = 4;
        "editor.insertSpaces" = true;
        "editor.wordWrap" = "on";
        "editor.minimap.enabled" = true;
        "editor.renderWhitespace" = "boundary";

        # Theme
        "workbench.colorTheme" = "Dracula";
        "workbench.iconTheme" = "material-icon-theme";

        # Terminal
        "terminal.integrated.fontFamily" = "JetBrains Mono";
        "terminal.integrated.fontSize" = 14;

        # Files
        "files.autoSave" = "onFocusChange";
        "files.trimTrailingWhitespace" = true;
        "files.insertFinalNewline" = true;

        # Git
        "git.enableSmartCommit" = false;
        "git.confirmSync" = true;

        # Language specific
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "${pkgs.nil}/bin/nil";

        # Python
        "python.defaultInterpreterPath" = "${pkgs.python3}/bin/python";

        # Formatting
        "editor.formatOnSave" = true;
        "[nix]" = {
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
        };
        "[python]" = {
          "editor.defaultFormatter" = "ms-python.black-formatter";
        };
      };

      keybindings = [
        {
          key = "ctrl+;";
          command = "workbench.action.terminal.toggleTerminal";
        }

      ];
    };
  };
}
