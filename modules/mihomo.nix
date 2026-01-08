{ config, pkgs, lib, ... }:
let
  cfgPath = "/etc/mihomo/config.yaml";
in
{
  services.mihomo = {
    enable = true;
    configFile = cfgPath;
    tunMode = true;
    webui = pkgs.metacubexd;
  };

  # 确保目录存在（以及权限）
  systemd.tmpfiles.rules = [
    "d /etc/mihomo 0700 root root - -"
    "d /etc/secrets 0700 root root - -"
  ];

  systemd.services.mihomo-sub-update = {
    description = "Update mihomo config.yaml from subscription";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      Type = "oneshot";
      EnvironmentFile = "/etc/secrets/mihomo-sub.env";
    };

    path = [ pkgs.curl pkgs.coreutils pkgs.diffutils pkgs.util-linux ];

    script = ''
      set -euo pipefail

      umask 077
      mkdir -p "$(dirname "${cfgPath}")"

      tmp="$(mktemp -t mihomo-config.XXXXXX)"
      trap 'rm -f "$tmp"' EXIT

      # 拉取订阅（跟随重定向、失败重试）
      curl -fL --retry 3 --retry-delay 2 --connect-timeout 10 --max-time 60 \
        "$SUB_URL" -o "$tmp"

      # 粗略防呆：避免拿到 HTML 报错页直接覆盖
      if head -n 1 "$tmp" | grep -qiE '<!doctype html|<html'; then
        echo "Downloaded content looks like HTML, abort."
        exit 1
      fi

      # 内容没变化就不 reload
      if [ -f "${cfgPath}" ] && cmp -s "$tmp" "${cfgPath}"; then
        exit 0
      fi

      install -m 0600 -o root -g root "$tmp" "${cfgPath}.new"
      mv -f "${cfgPath}.new" "${cfgPath}"

      # 热重载
      curl -fS -X PUT \
        -H "Authorization: Bearer $MIHOMO_SECRET" \
        "http://$MIHOMO_CONTROLLER/configs?force=true" \
        -d "{\"path\":\"${cfgPath}\"}"
    '';
  };

  systemd.timers.mihomo-sub-update = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "2m";
      OnUnitActiveSec = "6h";
      Persistent = true;
      RandomizedDelaySec = "10m";
      Unit = "mihomo-sub-update.service";
    };
  };
}
