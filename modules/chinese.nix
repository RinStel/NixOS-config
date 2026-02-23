{ config, pkgs, lib, ... }: {
# 设置系统的中文环境
  i18n = {
    defaultLocale = "zh_CN.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "zh_CN.UTF-8";
      LC_IDENTIFICATION = "zh_CN.UTF-8";
      LC_MEASUREMENT = "zh_CN.UTF-8";
      LC_MONETARY = "zh_CN.UTF-8";
      LC_NAME = "zh_CN.UTF-8";
      LC_NUMERIC = "zh_CN.UTF-8";
      LC_PAPER = "zh_CN.UTF-8";
      LC_TELEPHONE = "zh_CN.UTF-8";
      LC_TIME = "zh_CN.UTF-8";
   };

   supportedLocales = [ "zh_CN.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];
  };

  # 输入法配置（Fcitx5）
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
    qt6Packages.fcitx5-chinese-addons # fcitx5-chinese-addons
    fcitx5-gtk
    qt6Packages.fcitx5-configtool  # fcitx5-configtool
    fcitx5-nord 
   ];
   fcitx5.waylandFrontend = true;
  };

  # 中文字体优化
  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;          # 生成字体目录（对部分应用更友好）
    fontconfig.enable = true;

    packages = with pkgs; [
      cascadia-code
      noto-fonts 
      noto-fonts-cjk-sans    # 思源黑体 (无衬线)
      noto-fonts-cjk-serif   # 思源宋体 (衬线)
      noto-fonts-color-emoji

      source-han-sans
      source-han-serif
      sarasa-gothic
      wqy_microhei
      wqy_zenhei
      liberation_ttf
      dejavu_fonts
      corefonts
    ];

    fontconfig.defaultFonts = {
      sansSerif = [ "Noto Sans CJK SC" ];
      serif     = [ "Noto Serif CJK SC" ];
      #monospace = [ "Noto Sans Mono CJK SC" ];
    };
  };
}
