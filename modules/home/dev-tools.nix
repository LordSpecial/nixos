{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    go
    python3
    cmake
    ninja
    dsview
    stm32cubemx
    openocd
    gcc-arm-embedded
    llvmPackages_latest.clang-tools
  ];
}
