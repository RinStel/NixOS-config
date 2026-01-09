{ config, pkgs, ... }:

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
  xdg.configFile."kitty".source = ../dotfiles/.config/kitty;
  xdg.configFile."niri".source = ../dotfiles/.config/niri;

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
      # 5 分钟无操作 -> Noctalia 锁屏
      { timeout = 300; command = lockCmd; }
      # 再过 15 秒无操作 → 熄屏
      { timeout = 315; command = "${dpmsOffIfLocked}"; resumeCommand = "${dpmsOnIfNeeded}"; }
    ];
    events = {
      before-sleep = lockCmd;
      after-resume = dpmsOn;
    };
  };
}
