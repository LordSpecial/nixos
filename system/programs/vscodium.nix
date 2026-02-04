{
  pkgs,
  lib,
  ...
}:
let
  vscodiumWithLibstdcxx = pkgs.vscodium.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ pkgs.makeWrapper ];
    # Cortex-Debug ships native modules; libstdc++ must be visible to the extension host.
    postFixup =
      (old.postFixup or "")
      + ''
        wrapProgram $out/bin/codium \
          --prefix LD_LIBRARY_PATH : ${pkgs.gcc.cc.lib}/lib
      '';
  });
in
{
  programs.vscode = {
    enable = true;
    package = vscodiumWithLibstdcxx;

    profiles.default = {
      extensions =
        with pkgs.vscode-extensions;
        [
          # Language support
          llvm-vs-code-extensions.vscode-clangd
          ms-python.python
          ms-vscode.cpptools
          golang.go
          tamasfe.even-better-toml
          davidanson.vscode-markdownlint

          # Productivity & Tools
          ms-vscode.hexeditor
          ms-vscode.cmake-tools
          aaron-bond.better-comments
          tomoki1207.pdf
          mechatroner.rainbow-csv

          # Remote development
          ms-vscode-remote.remote-ssh
          ms-vscode.remote-explorer

          # Git
          eamodio.gitlens

          # GitHub Copilot (if you have access)
          github.copilot
          github.copilot-chat

          # MCU/Embedded development
          marus25.cortex-debug

        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "mayukaithemevsc";
            publisher = "gulajavaministudio";
            version = "3.2.4";
            sha256 = "sha256-V2hAxIVu2YWonwcIG+9n300b88jzPOnKYUFt1okSX4w=";
          }
          {
            name = "nix-ide";
            publisher = "jnoortheen";
            version = "0.4.23";
            sha256 = "sha256-MnuFMrP52CcWZTyf2OKSqQ/oqCS3PPivwEIja25N2D0=";
          }
          {
            name = "kubernetes-yaml-formatter";
            publisher = "kennylong";
            version = "2.5.0";
            sha256 = "sha256-pCwY17dV6MOcD4IJ+JI2b22En+F9c1KuXbYCHxGnIAc=";
          }
          {
            name = "jinjahtml";
            publisher = "samuelcolvin";
            version = "0.20.0";
            sha256 = "sha256-wADL3AkLfT2N9io8h6XYgceKyltJCz5ZHZhB14ipqpM=";
          }
          {
            name = "jsoncrack-vscode";
            publisher = "aykutsarac";
            version = "3.0.0";
            sha256 = "sha256-SwgUm6rIEp15Lc86UHTD5gVHrs9Mwbcwsb7LL5SGVy4=";
          }
          {
            name = "json2csv";
            publisher = "khaeransori";
            version = "1.0.0";
            sha256 = "sha256-K5qwUbHrguwaxCVFDMTeRw3/QLNXRG/l1OanT3VEJs0=";
          }
          {
            name = "qt-core";
            publisher = "theqtcompany";
            version = "1.8.0";
            sha256 = "sha256-qgtDiSHHZ7k8H55W5Or01UxAW3UaQRVSuOpAj/l021I=";
          }
          {
            name = "qt-qml";
            publisher = "theqtcompany";
            version = "1.8.0";
            sha256 = "sha256-x8D1jbCpQsVkGGCvnNWfAbbA+8Sn8oPQ/St9HTq1PVg=";
          }
          {
            name = "claude-code";
            publisher = "anthropic";
            version = "1.0.118";
            sha256 = "sha256-Z+oN25j7j8AQm4+jqtSOzuaDWQlPKnQyF5tVqyfjTLs=";
          }
          # MCU debugging extensions
          {
            name = "debug-tracker-vscode";
            publisher = "mcu-debug";
            version = "0.0.15";
            sha256 = "sha256-2u4Moixrf94vDLBQzz57dToLbqzz7OenQL6G9BMCn3I=";
          }
          {
            name = "peripheral-viewer";
            publisher = "mcu-debug";
            version = "1.6.0";
            sha256 = "sha256-nKK8HRzeqDixpdKmgacjhNzanJaTsAnYLC6nCbmWXuU=";
          }
          {
            name = "memory-view";
            publisher = "mcu-debug";
            version = "0.0.26";
            sha256 = "sha256-ie8O5SK3nyNRW5UDuBwrHzagcRsax22LnbQGghdK330=";
          }
          {
            name = "rtos-views";
            publisher = "mcu-debug";
            version = "0.0.11";
            sha256 = "sha256-WIVlHxvAek9PxcZkhon1XNB7TxX0VF0NYEoWsSIf1+0=";
          }
        ];

      userSettings = {
        # Editor settings (from your old config)
        "editor.fontFamily" = "JetBrains Mono, JetBrainsMono Nerd Font";
        "editor.fontLigatures" = true;
        "editor.formatOnSave" = true;
        "editor.suggestSelection" = "first";

        # Theme (updated to your preferred theme)
        "workbench.colorTheme" = "Mayukai Reversal";
        "workbench.startupEditor" = "none";

        # Terminal
        "terminal.integrated.fontLigatures.enabled" = true;
        "terminal.integrated.defaultProfile.linux" = "fish";
        "terminal.integrated.profiles.linux" = {
          fish = {
            path = "${pkgs.fish}/bin/fish";
            args = [
              "-l"
            ];
          };
        };

        # Files
        "files.autoSave" = "onFocusChange";
        "files.trimTrailingWhitespace" = true;
        "files.insertFinalNewline" = true;
        "files.associations" = {
          "*.log" = "json";
        };

        # Git
        "git.enableSmartCommit" = true;
        "git.confirmSync" = false;
        "git.autofetch" = true;
        "git.openRepositoryInParentFolders" = "always";

        # Security
        "security.workspace.trust.untrustedFiles" = "prompt";

        # Language specific
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "${pkgs.nil}/bin/nil";

        # Python
        "python.defaultInterpreterPath" = "${pkgs.python3}/bin/python";

        # C/C++
        "C_Cpp.intelliSenseEngine" = "disabled"; # You had this disabled
        "C_Cpp.markdownInComments" = "enabled";
        "C_Cpp.clang_format_style" = "file";
        "clangd.path" = "${pkgs.llvmPackages_latest.clang-tools}/bin/clangd";
        "clangd.arguments" = [
          "--clang-tidy"
        ];
        "clang-format.style" = "file";
        "cortex-debug.gdbPath" = "${pkgs.gcc-arm-embedded}/bin/arm-none-eabi-gdb";

        # QML
        "qt-qml.qmlls.useQmlImportPathEnvVar" = true;

        # Go
        "go.toolsManagement.autoUpdate" = true;
        "go.lintFlags" = [
          "unused"
          "deadcode"
        ];

        # CSV
        "[csv]" = {
          "editor.inlayHints.maximumLength" = 0;
        };
        "rainbow_csv.virtual_alignment_char" = "space";

        # CMake
        "cmake.configureOnOpen" = true;
        "cmake.enabledOutputParsers" = [
          "cmake"
          "gnuld"
          "msvc"
          "ghs"
          "diab"
        ];
        "cmake.options.statusBarVisibility" = "icon";
        "cmake.showOptionsMovedNotification" = false;

        # GitHub Copilot
        "github.copilot.editor.enableAutoCompletions" = true;
        "github.copilot.nextEditSuggestions.enabled" = true;

        # Markdown
        "markdown.preview.doubleClickToSwitchToEditor" = false;

        # Diff editor
        "diffEditor.ignoreTrimWhitespace" = false;

        # Formatting
        "[nix]" = {
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
        };
        "[c]" = {
          "editor.defaultFormatter" = "llvm-vs-code-extensions.vscode-clangd";
        };
        "[cpp]" = {
          "editor.defaultFormatter" = "llvm-vs-code-extensions.vscode-clangd";
        };
        "[objc]" = {
          "editor.defaultFormatter" = "llvm-vs-code-extensions.vscode-clangd";
        };
        "[objcpp]" = {
          "editor.defaultFormatter" = "llvm-vs-code-extensions.vscode-clangd";
        };
        "[python]" = {
          "editor.defaultFormatter" = "ms-python.black-formatter";
        };

        # Remote SSH platforms (from your old config)
        "remote.SSH.remotePlatform" = {
          "192.168.1.72" = "linux";
          "192.168.68.55" = "linux";
          "103.192.153.39" = "linux";
          "192.168.0.106" = "linux";
        };
      };

      keybindings = [
        {
          key = "ctrl+;";
          command = "workbench.action.terminal.toggleTerminal";
        }
        # Your custom keybinding from the old config
        {
          key = "shift+enter";
          command = "workbench.action.terminal.sendSequence";
          args = {
            text = "\\\r\n";
          };
          when = "terminalFocus";
        }
      ];
    };
  };
}
