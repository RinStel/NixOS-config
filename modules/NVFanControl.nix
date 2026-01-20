# 该模块用于接管BIOS对N卡风扇的调速设置
# 若要移除该脚本，请注意运行 `sudo nvidia-settings -a gpufancontrolstate=0` 来恢复硬件控制
# 该脚本针对 RTX2080Ti 做了微调适配

{ pkgs, ... }:

{

systemd.timers.NVFanControl = {
  wantedBy = [ "timers.target" ];
   timerConfig = {
      OnBootSec = "10s";
      OnUnitActiveSec = "3s";
    };
};

systemd.services.NVFanControl = {
    enable = true;
    description = "NVIDIA Auto Fan Control Bash Script";
    path = [
      pkgs.gawk     # used for sine wave curve calc
      pkgs.pciutils
    ];

    serviceConfig = {
      Type = "oneshot";

      # 只有检测到 NVIDIA PCI 设备时才允许运行
      ExecCondition = "${pkgs.bash}/bin/bash -lc 'lspci -Dn | grep -q \"10de:\"'";
    };

    wantedBy = [ "default.target" ];
    partOf = ["default.target" ];


    script = ''
  declare -i finalFanSpeed

  gpuTemp=$(/run/current-system/sw/bin/nvidia-settings -q gpucoretemp -c 0 2>/dev/null \
    | grep -Po "(?<=: )[0-9]+(?=\.)" | head -n1)

  # 读不到温度就默认半速
  if [ -z "$gpuTemp" ]; then
    finalFanSpeed=50
  else
    if [ "$gpuTemp" -le 50 ]; then
      finalFanSpeed=17
    elif [ "$gpuTemp" -ge 85 ]; then
      finalFanSpeed=100
    else
      finalFanSpeed=$(gawk -v t="$gpuTemp" 'BEGIN{
        minT=50; maxT=85;
        minF=17; maxF=100;
        s=(t-minT)/(maxT-minT);
        if (s<0) s=0; if (s>1) s=1;
        # smoothstep
        smooth=3*s*s - 2*s*s*s;
        f=minF + (maxF-minF)*smooth;
        if (f<0) f=0; if (f>100) f=100;
        printf "%.0f", f
      }')
    fi
  fi

  echo "Current Temp: $gpuTemp | Target Fan Speed: $finalFanSpeed"

  # 通常需要先启用手动风扇控制状态（如果你没设过的话）
  /run/current-system/sw/bin/nvidia-settings -a '[gpu:0]/GPUFanControlState=1' -c 0 >/dev/null 2>&1 || true
  /run/current-system/sw/bin/nvidia-settings -a GPUTargetFanSpeed="$finalFanSpeed" -c 0
    '';


  };
}
