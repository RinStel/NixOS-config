{ pkgs, ... }:

{
  programs.direnv.enable = true;

  home.packages = with pkgs; [
    # 终端与常用命令
    bat
    btop
    cmatrix
    git
    kitty
    lsd
    mpv
    playerctl
    ripgrep
    vim
    wget
    yazi
    zip
    unzip

    # 桌面集成与文件处理
    libsecret
    nemo
    nemo-fileroller  # nemo 压缩包处理插件
    nerd-fonts.jetbrains-mono
    seahorse

    # 多媒体与实用工具
    ffmpeg
    gamescope  # 游戏兼容性
    linux-wallpaperengine  # 壁纸
    mangohud  # 用于监视应用的 GPU 占用和帧率
    mpvpaper  # 壁纸
    sqlitestudio
    steamcmd  # steam 辅助
    wayscriber  # 屏幕批注工具

    # 娱乐
    hmcl
    netease-cloud-music-gtk
    protonplus
    spotify
    tsukimi  # emby

    # 开发相关依赖
    claude-code
    conda
    nodejs
    pnpm
    spec-kit

    # 较大型 GUI 应用
    google-chrome
    wechat-uos
    telegram-desktop
    libreoffice-qt
    obsidian
    typora
  ];
}
