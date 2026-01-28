{ pkgs, osConfig, ... }:

let
  passPath = osConfig.age.secrets.win11-rdp.path;

  win11Rdp = pkgs.writeShellApplication {
    name = "win11-rdp";
    runtimeInputs = [ pkgs.freerdp ];
    text = ''
      set -euo pipefail
      pass="$(< ${passPath})"
      printf '%s\n' "$pass" | xfreerdp \
        /v:192.168.122.129 /u:YSChain@163.com /from-stdin \
        /w:2880 /h:1800 /scale:180 /scale-device:180 /scale-desktop:180 \
        /cert:ignore /bpp:32 /gfx:AVC444 +clipboard
    '';
  };
in {
  home.packages = [ win11Rdp ];

  xdg.desktopEntries.win11-rdp = {
    name = "Win11 (RDP)";
    comment = "FreeRDP to local KVM Win11";
    exec = "win11-rdp";          # 直接用命令名
    terminal = false;
    categories = [ "Network" "RemoteAccess" ];
    icon = "computer";
  };
}
