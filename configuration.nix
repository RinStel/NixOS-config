# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "forge"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.wireless.enable = true;

  # Configure network proxy if necessary
  #networking.proxy.default = "http://127.0.0.1:7890/";
  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # PPD
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

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

  # Enable the GNOME Desktop Environment.
 # services.xserver.displayManager.gdm.enable = true;
 # services.xserver.desktopManager.gnome.enable = true;
  services.desktopManager.gnome.enable = false;
  services.displayManager.gdm.enable = true;
  services.displayManager.gdm.wayland = true;
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
  services.printing.enable = true;

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
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.zikun = {
    isNormalUser = true;
    description = "zikun";
    extraGroups = [ "networkmanager" "wheel" "video" "input" "libvirtd" "qemu" "kvm" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # enable Hyprland
  programs.hyprland.enable = false; 

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
  
  services.logind.settings.Login = {
    HandlePowerKey = "ignore";
    # 建议保留，避免刚恢复时设备状态抖动
    HoldoffTimeoutSec = "30s";
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  system.stateVersion = "26.05"; # Did you read the comment?

}
