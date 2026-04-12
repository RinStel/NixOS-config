{ config, pkgs, ... }:

let
  wechatWrapped = pkgs.symlinkJoin {
    name = "wechat-fcitx";
    paths = [ pkgs.wechat ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      rm "$out/bin/wechat"
      makeWrapper "${pkgs.wechat}/bin/wechat" "$out/bin/wechat" \
        --set GTK_IM_MODULE fcitx \
        --set QT_IM_MODULE fcitx \
        --set XMODIFIERS "@im=fcitx" \
        --set SDL_IM_MODULE fcitx \
        --set QT_QPA_PLATFORM xcb
    '';
  };
in

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
    ripgrep
    smartmontools # 硬盘监控

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
    steamcmd  # steam workshop下载工具

    # 娱乐
    protonplus
    mpvpaper # 壁纸
    linux-wallpaperengine # 壁纸
    tsukimi  # emby
    #prismlauncher  # MC
    hmcl

    # 开发相关依赖
    nodejs
    pnpm
    conda

    # Vibe Coding
    #claude-code 暂时禁用
    codex
    spec-kit

    # (较)大型第三方软件
    google-chrome
    spotify
    telegram-desktop
    wechatWrapped
    libreoffice-qt
    typora
    obsidian
    netease-cloud-music-gtk
  ];

  # ToDesk
  #services.todesk.enable = true;

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
    update.onActivation = false;

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
}
