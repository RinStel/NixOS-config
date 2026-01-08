{ config, pkgs, ... }:

{
  home.username = "zikun";
  home.homeDirectory = "/home/zikun";
  home.stateVersion = "26.05";

  gtk = {
    enable = true;
    colorScheme = "dark";
    
    gtk4 = {
      enable = true;
      colorScheme = "dark";
    };
  };
  
  programs.home-manager.enable = true;
  home.file.".bashrc".source = ./dotfiles/.bashrc;
  home.file.".inputrc".source = ./dotfiles/.inputrc;
  home.file.".vimrc".source = ./dotfiles/.vimrc;

  xdg.enable = true;
  xdg.configFile."btop".source = ./dotfiles/.config/btop;
  xdg.configFile."fastfetch".source = ./dotfiles/.config/fastfetch;
  xdg.configFile."kitty".source = ./dotfiles/.config/kitty;
  xdg.configFile."niri".source = ./dotfiles/.config/niri;

  
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
