{ pkgs, ... }:
# 解决某些环境编译失败/缺少动态库
{
  programs.nix-ld.enable = true;

  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc   # libstdc++.so
    zlib           # libz.so
    zstd
    curl
    openssl
  ];
}
