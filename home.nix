{ config, pkgs, ... }:

{
  home.username = "zikun";
  home.homeDirectory = "/home/zikun";
  home.stateVersion = "25.11";
  
  programs.home-manager.enable = true;
  home.file.".bashrc".source = ./dotfiles/.bashrc;
  home.file.".inputrc".source = ./dotfiles/.inputrc;
  home.file.".vimrc".source = ./dotfiles/.vimrc;

  xdg.enable = true;
  xdg.configFile."alacritty".source = ./dotfiles/.config/alacritty;
  xdg.configFile."alacritty".recursive = true;
  xdg.configFile."btop".source = ./dotfiles/.config/btop;
  xdg.configFile."btop".recursive = true;
  xdg.configFile."fastfetch".source = ./dotfiles/.config/fastfetch;
  xdg.configFile."fastfetch".recursive = true;
  xdg.configFile."hypr".source = ./dotfiles/.config/hypr;
  xdg.configFile."hypr".recursive = true;
  xdg.configFile."kitty".source = ./dotfiles/.config/kitty;
  xdg.configFile."kitty".recursive = true;
  xdg.configFile."niri".source = ./dotfiles/.config/niri;
  xdg.configFile."niri".recursive = true;

}
