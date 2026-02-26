{ config, pkgs, ... }:

{
  programs.direnv.enable = true;

  # Install firefox.
  #programs.firefox.enable = true;
  
# 启用 virt-manager 程序
  programs.virt-manager.enable = true;

  services.gnome.gnome-keyring.enable = true;

  services.gvfs.enable = true;
  services.tumbler.enable = true;

  environment.systemPackages = with pkgs; [
    # 基础软件包
    usbutils
    vim
    wget
    git
    starship
    kitty
    fastfetch
    playerctl
    nerd-fonts.jetbrains-mono
    libsecret
    seahorse
    zip    
    unzip
    mpv
    iputils
    lsof

    # 工具类
    mangohud  # 用于监视应用的GPU占用和帧率
    gamescope # 游戏兼容性
    wayscriber # 屏幕批注工具
    btop
    cmatrix
    #obsidian
    yazi
    bat
    lsd
    wireguard-tools
    sqlitestudio
    ffmpeg
    nemo
    nemo-fileroller  # nemo 压缩包处理插件

    # 娱乐
    protonplus
    kodi

    # 开发相关依赖
    nodejs
    pnpm

    # Vibe Coding
    claude-code
    spec-kit

    # (较)大型第三方软件
    google-chrome
    spotify
    telegram-desktop
    wechat-uos
    libreoffice-qt
    typora
    obsidian
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

    # 严格模式：移除所有未在 packages/remotes 里声明的项
    uninstallUnmanaged = true;

    # 激活时更新（默认 false）
    update.onActivation = true;

    # 定时自动更新（系统激活时也会触发）
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
