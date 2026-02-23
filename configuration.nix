# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.overlays = [
    # 在此添加overlay
  ];


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "forge"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.wireless.enable = true;
  hardware.bluetooth.enable = true;

  # Configure network proxy if necessary
  networking.enableIPv6 = false;  # 禁用IPv6以避免某些神秘问题
  networking.proxy.default = "http://127.0.0.1:7890/";
  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";


  # DNS
  services.resolved = {
    enable = true;
    settings.Resolve.DNSOverTLS = "yes";
  };
  # 这里的 #dns.alidns.com 用于 TLS SNI/证书名匹配
  networking.nameservers = [
    "223.5.5.5#dns.alidns.com"
    "223.6.6.6#dns.alidns.com"
  ];


  # ---------电源管理与省电---------
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  # NixOS 自带电源管理基线 + powertop 自动调优
  powerManagement.enable = true;
  # 注意：powertop会自动挂起外部设备，可能会导致断开连接
  #powerManagement.powertop.enable = true;

  # CPU 调速策略
  powerManagement.cpuFreqGovernor = "ondemand"; # 或 "powersave"
  # Wi-Fi 省电（可能提升续航；若掉线/高延迟就改回 false）
  networking.networkmanager.wifi.powersave = true;
  # --------------------------------


  security.polkit.enable = true;

  # 开启flake
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # 镜像源配置
  nix.settings = {
    substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store?priority=10"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=5"
      "https://cache.nixos.org/"
    ];
    # 增加下载缓冲区大小
    download-buffer-size = 524288000;
  };

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Enable the X11 windowing system.
  services.xserver.enable = true;


  services.displayManager.defaultSession = "niri";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };


  # 为gnome视频软件使用openGl
    environment.sessionVariables = {
    GDK_GL = "gles";
    };

  # Enable CUPS to print documents.
  #services.printing.enable = true;
  #services.printing.drivers = [ pkgs.hplip ];

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true; 
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.zikun = {
    isNormalUser = true;
    description = "zikun";
    extraGroups = [
      "networkmanager" "wheel" "video" "input"
      "dialout"   # /dev/ttyUSB*, /dev/ttyACM*
      "plugdev"   # 一些调试器用
    ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;  # Allow unfree packages
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

    brightnessctl

   gnome-extension-manager
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
  ];

  # Attention this
  environment.pathsToLink = [
    "/share/fastfetch"
    "/share/wayland-sessions"
  ];

  # 处理 USB 权限问题
  services.udev.extraRules = ''
    # STM32 DFU
    SUBSYSTEM=="usb", ATTR{idVendor}=="0483", MODE="0666"

    # ST-Link
    SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="3748", MODE="0666"

    # SEGGER J-Link
    SUBSYSTEM=="usb", ATTR{idVendor}=="1366", MODE="0666"

    # CH340
    SUBSYSTEM=="usb", ATTR{idVendor}=="1a86", MODE="0666"

    # CP210x
    SUBSYSTEM=="usb", ATTR{idVendor}=="10c4", MODE="0666"

    # 通用串口
    KERNEL=="ttyUSB*", MODE="0666"
    KERNEL=="ttyACM*", MODE="0666"
  '';

  # 尽量修复字体模糊
  fonts.fontconfig = {
    enable = true;
    antialias = true;
  
    hinting = {
      enable = true;
      style = "medium";
      autohint = true;
    };
  
    subpixel = {
      rgba = "none";       # 如果出现彩边/更虚，尝试 "rgb" 或 "bgr"
      lcdfilter = "default";
    };
  };


  services.logind.settings.Login = {
    # 合盖时挂起
    HandleLidSwitch = "suspend";
    # 接外接电源时合盖挂起（可按需改成 "ignore"/"lock", 但lock有信号传递上的问题）
    HandleLidSwitchExternalPower = "suspend";
    # 外接显示器/“docked”状态下的合盖行为
    HandleLidSwitchDocked = "suspend";
  };

  # 解决切换到Windows系统后时间异常的问题
  time.hardwareClockInLocalTime = true;

  # 修复：无法连接不遵循规范的的WPA2企业网络
  systemd.services.wpa_supplicant.environment.OPENSSL_CONF = pkgs.writeText "openssl.cnf" ''
    openssl_conf = openssl_init
    [openssl_init]
    ssl_conf = ssl_sect
    [ssl_sect]
    system_default = system_default_sect
    [system_default_sect]
    Options = UnsafeLegacyRenegotiation
    [system_default_sect]
    CipherString = Default:@SECLEVEL=0
  '';

  # 修复：字体解析异常
  environment.sessionVariables = {
    FONTCONFIG_FILE = "/etc/fonts/fonts.conf";
    FONTCONFIG_PATH = "/etc/fonts";
  };


  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  system.stateVersion = "26.05"; # Did you read the comment?

}
