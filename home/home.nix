{ config, pkgs, lib, ... }:

let
  configDir = ./modules;
  generatedModules = lib.map (file: configDir + "/${file}")
    (lib.filter (file: lib.hasSuffix ".nix" file)
    (lib.attrNames (builtins.readDir configDir)));

in

{
  home.username = "zikun";
  home.homeDirectory = "/home/zikun";
  home.stateVersion = "26.05";

  imports = generatedModules;

  gtk = {
    enable = true;
    colorScheme = "dark";
    
    gtk4 = {
      enable = true;
      colorScheme = "dark";
    };

    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };
  
  programs.home-manager.enable = true;
  home.file.".bashrc".source = ../dotfiles/.bashrc;
  home.file.".inputrc".source = ../dotfiles/.inputrc;
  home.file.".vimrc".source = ../dotfiles/.vimrc;

  xdg.enable = true;
  #xdg.configFile."btop".source = ../dotfiles/.config/btop;
  xdg.configFile."fastfetch".source = ../dotfiles/.config/fastfetch;

  # --- 下面这部分对 Noctalia 的主题联动做了适配 ---
  xdg.configFile."kitty/kitty.conf".source = ../dotfiles/.config/kitty/kitty.conf;
  xdg.configFile."kitty/scroll_mark.py".source = ../dotfiles/.config/kitty/scroll_mark.py;
  xdg.configFile."kitty/search.py".source = ../dotfiles/.config/kitty/search.py;

  xdg.configFile."niri/config.kdl".source = ../dotfiles/.config/niri/config.kdl;

  # 确保 Noctalia 要写的文件存在且为“普通文件”（不是 symlink）
  home.activation.fixNoctaliaWritableTargets = lib.hm.dag.entryBefore ["writeBoundary"] ''
    # 1) 先把 ~/.config/kitty 和 ~/.config/niri 从 symlink 还原成真实目录
    if [ -L "$HOME/.config/kitty" ]; then rm -f "$HOME/.config/kitty"; fi
    if [ -L "$HOME/.config/niri" ]; then rm -f "$HOME/.config/niri"; fi
    mkdir -p "$HOME/.config/kitty" "$HOME/.config/niri"

    # 2) 确保 noctalia 输出文件是“普通文件”（不是 symlink）
    if [ -L "$HOME/.config/kitty/noctalia.conf" ]; then rm -f "$HOME/.config/kitty/noctalia.conf"; fi
    if [ -L "$HOME/.config/niri/noctalia.kdl" ]; then rm -f "$HOME/.config/niri/noctalia.kdl"; fi

    test -e "$HOME/.config/kitty/noctalia.conf" || : > "$HOME/.config/kitty/noctalia.conf"
    test -e "$HOME/.config/niri/noctalia.kdl" || : > "$HOME/.config/niri/noctalia.kdl"
  '';
  # ------------------------------------------------


  # 将kitty作为默认终端
  xdg.dataFile."xfce4/helpers/kitty.desktop".text = ''
    [Desktop Entry]
    Version=1.0
    Type=X-XFCE-Helper
    Name=kitty
    StartupNotify=true
    X-XFCE-Binaries=kitty;
    X-XFCE-Category=TerminalEmulator
    X-XFCE-Commands=kitty;
    X-XFCE-CommandsWithParameter=kitty -e "%s";
    Icon=kitty
  '';

  xdg.configFile."xfce4/helpers.rc".text = ''
    TerminalEmulator=kitty
    TerminalEmulatorDismissed=true
  '';

}
