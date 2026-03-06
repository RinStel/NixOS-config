{ pkgs, inputs, ... }:
# 此处使用官方提供的rust版codex，更新时需要`sudo nix flake update`
{
  environment.systemPackages = [
    inputs.codex.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
