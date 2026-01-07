{ config, pkgs, ... }:

{
# Install firefox.
  programs.firefox.enable = true;

# 安装  flatpak
  services.flatpak.enable = true;
  
# 启用 virt-manager 程序
  programs.virt-manager.enable = true;

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true;

  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs; [
    thunar-volman
    thunar-archive-plugin
    thunar-media-tags-plugin
  ];
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    starship
    kitty
    fastfetch
    
    unzip

    nerd-fonts.jetbrains-mono
    helix
    btop
    cmatrix
    obsidian
    yazi
    bat
    lsd
    wireguard-tools

    google-chrome
    telegram-desktop
    spotify
    playerctl

    libsecret
    seahorse
  ];

# 启用 libvirt 服务
  virtualisation.libvirtd = {
    enable = true;
   # 启用 virtiofsd 支持，这会自动处理 qemu 依赖
    qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
  };
}
