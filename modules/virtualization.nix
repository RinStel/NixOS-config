# virtualization.nix (unstable, AMD, virtiofs share, PCI passthrough-ready)
{ pkgs, ... }:
{
  virtualisation = {
    docker.enable = false;
    podman = {
      enable = true;
      dockerCompat = true;   # 让 docker 命令也能跑
      defaultNetwork.settings.dns_enabled = true;
    };

    libvirtd = {
      enable = true;
      onBoot = "start";
      onShutdown = "shutdown";

      # 如果你系统是 nftables，建议让 libvirt 也用 nftables（避免规则分裂）
      # firewallBackend = "nftables";

      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = false;     # 非特权 qemu（需要注意权限，见下）
        swtpm.enable = true;   # Win11/TPM（你没开BitLocker也不冲突）

        # 共享目录（virtiofs）必需
        vhostUserPackages = with pkgs; [ virtiofsd ];

        # 建议先去掉你原来的 verbatimConfig（避免覆盖模块默认qemu.conf）
        # verbatimConfig = "";
      };
    };

    spiceUSBRedirection.enable = true;
  };

  programs.virt-manager.enable = true;
  programs.dconf.enable = true;

  users.users.zikun.extraGroups = [ "libvirtd" "kvm" "qemu" ];

  environment.systemPackages = with pkgs; [
    # 默认 NAT 网络（virbr0）所需
    dnsmasq
    virt-viewer
    libguestfs

    # 虚拟化容器
    distrobox
    xdg-utils
  ];

  # PCI passthrough：VFIO 模块放 initrd，保证早于显卡等早期驱动加载
  boot.initrd.kernelModules = [
    "vfio_pci"
    "vfio"
    "vfio_iommu_type1"
  ];

  # AMD IOMMU
  boot.kernelParams = [
    "amd_iommu=on"
    "iommu=pt"
    # 需要直通某设备时再加，例如：
    # "vfio-pci.ids=1002:XXXX,1002:YYYY"
  ];

  # 只保留 AMD 的 KVM 模块（通常也可不写，内核会自动加载）
  boot.kernelModules = [ "kvm-amd" ];

  # NAT + 转发（你要让 Windows 流量跟宿主共网、走 mihomo tun 时通常需要）
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  networking.firewall.trustedInterfaces = [ "virbr0" ];
  networking.firewall.checkReversePath = false;
}

