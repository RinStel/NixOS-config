{ config, pkgs, ... }:

{
# Install firefox.
  programs.firefox.enable = true;

# 安装  flatpak
  services.flatpak.enable = true;
  
# 启用 virt-manager 程序
  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    starship
    kitty
    fastfetch
    nerd-fonts.jetbrains-mono
    helix
    btop
    cmatrix
    obsidian
    yazi
    bat
    lsd
    wireguard-tools
 ];


# 启用 libvirt 服务
  virtualisation.libvirtd = {
    enable = true;
   # 启用 virtiofsd 支持，这会自动处理 qemu 依赖
    qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
  };
}
