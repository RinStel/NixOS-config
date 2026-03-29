{ pkgs, ... }:

{
  # 录屏支持
  programs.gpu-screen-recorder.enable = true;

  xdg.portal = {
    enable = true;

    # 让 niri 提供的 niri-portals.conf 生效
    configPackages = [
      pkgs.niri
      pkgs.gnome-session  # 提供 gnome portal 相关 desktop 标识/配置来源
    ];

    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];

    config.common = {
      default = "gtk";
      "org.freedesktop.impl.portal.ScreenCast" = "wlr";
      "org.freedesktop.impl.portal.Screenshot"  = "wlr";
    };
  };
}
