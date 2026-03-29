{ config, pkgs, ... }:

{
  #programs.firefox.enable = true;

  programs.virt-manager.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  environment.systemPackages = with pkgs; [
    # 运维与诊断命令
    fastfetch
    usbutils
    iputils
    lsof
    smartmontools
    starship
    wireguard-tools
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
