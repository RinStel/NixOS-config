{ config, lib, pkgs, ... }:

let
  # 建议使用稳定的 by-id 路径，而不是 /dev/nvme0n1 这类可能变化的名字。
  # 使用: ls -l /dev/disk/by-id
  monitoredDevices = [
    "/dev/disk/by-id/nvme-ZHITAI_TiPlus7100_1TB_ZTA71T0AB253517665"
    # ...
  ];
in
{
  services.systembus-notify.enable = true;

  services.smartd = {
    enable = true;

    # 显式指定设备时，关闭自动扫描
    autodetect = false;

    notifications = {
      systembus-notify.enable = true;
    };

    # 显式列出的 devices 的通用默认参数。
    # -a              启用常见 SMART 监测项
    # -s S/../.././23 每天 23 点执行一次 short self-test
    defaults.monitored = "-a -s S/../.././23";

    devices = map (device: {
      inherit device;
      # 如需给某块盘单独覆写参数，可取消下面这行注释：
      # options = "-a -s S/../.././23";
    }) monitoredDevices;
  };
}
