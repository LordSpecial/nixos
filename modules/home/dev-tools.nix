{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # Language runtimes and toolchains
    go
    python3
    rustc
    cargo
    clippy
    typescript

    # LSP servers used by Claude plugins
    gopls
    pyright
    rust-analyzer
    typescript-language-server
    llvmPackages_latest.clang-tools # provides clangd

    # Browser automation tooling
    pkgs."playwright-driver" # core Playwright driver package
    pkgs."playwright-test" # provides playwright CLI + bundled browsers path

    # Native build tooling
    cmake
    ninja

    # Shell environment tooling
    direnv
    pkgs."nix-direnv"

    # Embedded tooling
    dsview
    stm32cubemx
    openocd
    gcc-arm-embedded
  ];

  home.sessionVariables = {
    # Ensure project-local `npx playwright` uses Nix-provided browsers.
    PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  };
}
