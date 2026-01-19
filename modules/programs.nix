{ config, pkgs, ... }:

{
  programs.direnv.enable = true;

  # Install firefox.
  #programs.firefox.enable = true;
  
# 启用 virt-manager 程序
  programs.virt-manager.enable = true;

  services.gnome.gnome-keyring.enable = true;

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

    zip    
    unzip

    nerd-fonts.jetbrains-mono
    helix
    btop
    cmatrix
    #obsidian
    #yazi
    bat
    lsd
    wireguard-tools

    google-chrome
    spotify
    playerctl
    telegram-desktop

    wechat-uos
    onlyoffice-desktopeditors

    libsecret
    seahorse
  ];

  services.flatpak = {
    enable = true;

    # 可选：显式声明 remotes（不写也会默认添加 flathub）
    # remotes = [
    #   { name = "flathub"; location = "https://dl.flathub.org/repo/flathub.flatpakrepo"; }
    # ];

    packages = [
      "com.dingtalk.DingTalk"  # Flathub 上的 DingTalk AppID
    ];

    # 可选：严格模式——移除所有未在 packages/remotes 里声明的项
    # uninstallUnmanaged = true;

    # 可选：激活时更新（默认 false）
    update.onActivation = true;

    # 可选：定时自动更新（系统激活时也会触发）
    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };
  };

  # 安装 Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remoteplay
    dedicatedServer.openFirewall = true; # Open ports in the firewall for steam server
  };


# 启用 libvirt 服务
  virtualisation.libvirtd = {
    enable = true;
   # 启用 virtiofsd 支持，这会自动处理 qemu 依赖
    qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
  };
}
