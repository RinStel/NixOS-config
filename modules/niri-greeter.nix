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

    # regreet.toml 的设置（可选：你先不配背景也行；只靠 CSS/主题也能统一）
    settings = {
      # background = {
      #   path = "/etc/greetd/background.png";
      #   fit = "Cover";
      # };
    };



    extraCss = ''
  /* --- Noctalia-ish neutral palette + blue accent --- */
  @define-color bg0 rgba(10, 12, 16, 0.96);
  @define-color card rgba(18, 22, 30, 0.72);
  @define-color fg  rgba(235, 238, 245, 0.92);
  @define-color fg2 rgba(235, 238, 245, 0.78);
  @define-color line rgba(255, 255, 255, 0.10);

  /* 你的 noctalia accent（仍用 #7fc8ff，但不再“实心刺眼”） */
  @define-color accent #7fc8ff;

  window {
    background: @bg0;
  }

  /* 背景透明，主要由 frame/card 提供“磨砂卡片” */
  box, grid, overlay {
    background: transparent;
  }

  label {
    color: @fg;
  }
  label:disabled {
    color: @fg2;
  }

  entry, combobox, button {
    border-radius: 16px;
  }

  /* 登录卡片（regreet 通常会包一层 frame） */
  frame {
    background: @card;
    border: 1px solid rgba(127, 200, 255, 0.16);
    box-shadow: 0 18px 45px rgba(0, 0, 0, 0.55);
    padding: 18px;
  }

  entry {
    background: rgba(12, 14, 18, 0.55);
    color: @fg;
    border: 1px solid @line;
    padding: 10px 12px;
  }
  entry:focus {
    border-color: rgba(127, 200, 255, 0.30);
  }

  button {
    background: rgba(18, 22, 30, 0.60);
    color: @fg;
    border: 1px solid @line;
    padding: 10px 14px;
  }
  button:hover {
    background: rgba(24, 28, 38, 0.70);
    border-color: rgba(127, 200, 255, 0.18);
  }

  /* Login 按钮：降低亮度（改为半透明 accent + 深色文字 + 轻阴影） */
  button.suggested-action, button.default {
    background: rgba(127, 200, 255, 0.74);
    color: rgba(10, 12, 16, 1.0);
    border: 1px solid rgba(127, 200, 255, 0.28);
    box-shadow: 0 10px 24px rgba(127, 200, 255, 0.12);
  }
  button.suggested-action:hover, button.default:hover {
    background: rgba(127, 200, 255, 0.82);
    border-color: rgba(127, 200, 255, 0.38);
    box-shadow: 0 12px 28px rgba(127, 200, 255, 0.16);
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

      // 让 greeter 的 GTK theme 和 programs.regreet.theme 一致
      GTK_THEME "adw-gtk3-dark"
    }

    // 用 programs.regreet 生成的包路径更一致
    spawn-at-startup "sh" "-lc" "${config.programs.regreet.package}/bin/regreet; ${pkgs.niri}/bin/niri msg action quit --skip-confirmation"
  '';
}
