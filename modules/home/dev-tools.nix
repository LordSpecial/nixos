{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    go
    python3
    cmake
    openocd
    gcc-arm-embedded
    llvmPackages_latest.clang-tools
  ];
}
