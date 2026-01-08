{ config, pkgs, lib, ... }:

{
  users.groups.greeter = {};
  users.users.greeter = {
    isSystemUser = true;
    group = "greeter";
    extraGroups = [ "video" "input" ];
  };

  services.greetd = {
    enable = true;
    settings.default_session = {
      user = "greeter";
      command = "${pkgs.dbus}/bin/dbus-run-session ${pkgs.niri}/bin/niri -c /etc/greetd/niri-greeter.kdl";
    };
  };


  programs.regreet = {
    enable = true;

    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };

    font = {
      name = "Noto Sans";
      package = pkgs.noto-fonts;
      size = 12;
    };

    # regreet.toml 的设置
    settings = {
      #background = {
      #  path = "/etc/greetd/background.png";
      #  fit = "Cover";
      #};
    };

    # 用 CSS 拉近 Noctalia / 你 niri 的风格：暗底、半透明、圆角、蓝色强调
    extraCss = ''
      window {
        background: rgba(29, 32, 33, 0.92);
      }

      box, grid, overlay {
        background: transparent;
      }

      entry, combobox, button {
        border-radius: 10px;
      }

      entry {
        background: rgba(60, 56, 54, 0.65);
        color: #ebdbb2;
        border: 1px solid rgba(127, 200, 255, 0.35);
        padding: 8px 10px;
      }

      button {
        background: rgba(60, 56, 54, 0.65);
        color: #ebdbb2;
        border: 1px solid rgba(127, 200, 255, 0.25);
        padding: 8px 12px;
      }

      button.suggested-action, button.default {
        background: #7fc8ff;
        color: #1d2021;
        border: none;
      }

      button:hover {
        border-color: rgba(127, 200, 255, 0.55);
      }

      label {
        color: #ebdbb2;
      }
    '';
  };


  environment.etc."greetd/niri-greeter.kdl".text = ''
    // 登录时只亮内屏 (内屏设为启动聚焦)
    output "eDP-1" {
      focus-at-startup
      scale 1.75
      mode "2880x1800@120.000"
    }
    output "HDMI-A-1" {
      off
    }

    hotkey-overlay {
      skip-at-startup
    }

    environment {
      GTK_USE_PORTAL "0"
      GDK_DEBUG "no-portals"

      XCURSOR_THEME "Bibata-Modern-Ice"
      XCURSOR_SIZE "24"

      # 让 greeter 的 GTK theme 和 programs.regreet.theme 一致
      GTK_THEME "adw-gtk3-dark"
    }

    spawn-at-startup "sh" "-c" "${pkgs.greetd.regreet}/bin/regreet; ${pkgs.niri}/bin/niri msg action quit --skip-confirmation"
  '';

}
