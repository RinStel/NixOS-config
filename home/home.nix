{ config, pkgs, lib, ... }:

let
  lockCmd = "${config.home.profileDirectory}/bin/noctalia-shell ipc call lockScreen lock";
  dpmsOff = "${pkgs.niri}/bin/niri msg action power-off-monitors";
  dpmsOn  = "${pkgs.niri}/bin/niri msg action power-on-monitors";


  # Noctalia 的 lockScreen（ext-session-lock）在 niri 下会更新 logind 的 LockedHint（可用于判断是否处于锁定）
  # 参考：niri issue #2439 的描述。:contentReference[oaicite:2]{index=2}
  dpmsOffIfLocked = pkgs.writeShellScript "dpms-off-if-locked" ''
    set -eu
    sid="''${XDG_SESSION_ID:-self}"
    locked="$(${pkgs.systemd}/bin/loginctl show-session "$sid" -p LockedHint --value 2>/dev/null || echo no)"
    if [ "$locked" = "yes" ]; then
      ${dpmsOff}
      : > "''${XDG_RUNTIME_DIR}/dpms_off_by_idle"
    fi
  '';
  dpmsOnIfNeeded = pkgs.writeShellScript "dpms-on-if-needed" ''
    set -eu
    f="''${XDG_RUNTIME_DIR}/dpms_off_by_idle"
    if [ -e "$f" ]; then
      rm -f "$f"
      ${dpmsOn}
    fi
  '';
in

{
  home.username = "zikun";
  home.homeDirectory = "/home/zikun";
  home.stateVersion = "26.05";

  imports = [
    ./modules/vscode.nix
  ];

  gtk = {
    enable = true;
    colorScheme = "dark";
    
    gtk4 = {
      enable = true;
      colorScheme = "dark";
    };
  };
  
  programs.home-manager.enable = true;
  home.file.".bashrc".source = ../dotfiles/.bashrc;
  home.file.".inputrc".source = ../dotfiles/.inputrc;
  home.file.".vimrc".source = ../dotfiles/.vimrc;

  xdg.enable = true;
  xdg.configFile."btop".source = ../dotfiles/.config/btop;
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


  services.swayidle = {
    enable = true;
    timeouts = [
      # 5 分钟无操作 -> Noctalia 锁定
      { timeout = 300; command = lockCmd; }
      # 再过 25 秒无操作 → 熄屏
      { timeout = 325; command = "${dpmsOffIfLocked}"; resumeCommand = "${dpmsOnIfNeeded}"; }
      # 主动锁定的情况
      { timeout = 15; command = "${dpmsOffIfLocked}"; resumeCommand = "${dpmsOnIfNeeded}"; }
    ];
    events = {
      before-sleep = lockCmd;
      after-resume = dpmsOn;
    };
  };
}
