{ pkgs, inputs, lib, ... }:

{
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # 录屏支持
  programs.gpu-screen-recorder.enable = true;

  environment.systemPackages = with pkgs; [
    gpu-screen-recorder-gtk # GUI app
  ];

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

  home-manager.users.zikun = { config, pkgs, lib, ... }: {
    home.packages = with pkgs; [
      gpu-screen-recorder
      gpu-screen-recorder-gtk
    ];

    imports = [
      inputs.noctalia.homeModules.default
    ];

    programs.noctalia-shell = {
      enable = true;

      # 警告：这会导致无法手动安装插件
      plugins = {
        version = 1;

        sources = [
          {
            enabled = true;
            name = "Official Noctalia Plugins";
            url = "https://github.com/noctalia-dev/noctalia-plugins";
          }
        ];

        states = {
          screen-recorder = {
            enabled = true;
            sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
          };
        };
      };
    };

    # 把“种子配置”放到 XDG 里
    xdg.configFile."noctalia/settings.seed.json".source = ./noctalia-settings.json;

    # 激活时：确保 settings.json 是普通可写文件，并在重建时从 seed 复制
    home.activation.noctaliaSeedSettings =
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        cfg="$HOME/.config/noctalia"
        mkdir -p "$cfg"

        seed="$cfg/settings.seed.json"
        target="$cfg/settings.json"

        # 如果历史上被 HM 做成 symlink（只读），先还原成普通文件
        if [ -L "$target" ]; then
          rm -f "$target"
        fi

        # 在重建时从 seed 复制
        cp "$seed" "$target"
      '';
  };
}
