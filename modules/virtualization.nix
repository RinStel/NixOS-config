# virtualization.nix (unstable, AMD, virtiofs share, PCI passthrough-ready)
{ pkgs, lib, ... }:
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

        verbatimConfig = ''
          # 允许 qemu 访问 render node（以及其它默认设备）
          cgroup_device_acl = [
            "/dev/null", "/dev/full", "/dev/zero",
            "/dev/random", "/dev/urandom",
            "/dev/ptmx", "/dev/kvm",
            "/dev/dri/renderD128"
          ]
        '';
      };
    };

    spiceUSBRedirection.enable = true;
  };

  programs.virt-manager.enable = true;
  programs.dconf.enable = true;

  # 将用户添加进组
  users.users.zikun.extraGroups = lib.mkAfter [ "libvirtd" "kvm" "qemu" "render" "video" ];
  users.users.qemu-libvirtd.extraGroups = [ "render" "video" ]; # 血的教训

  environment.systemPackages = with pkgs; [
    # virgl/mesa 运行时
    mesa
    virglrenderer
    spice-gtk
    virt-viewer

    dnsmasq # 默认 NAT 网络（virbr0）所需
    libguestfs

    distrobox # 虚拟化容器(其实不该放在这个模块)
    podman-compose # 用于compose
    xdg-utils

    # RDP
    freerdp   # 提供 xfreerdp / wlfreerdp 等
    remmina  # 可选：GUI 客户端
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

  # NAT + 转发（让 Windows 流量跟宿主共网、走 mihomo tun 时通常需要）
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  networking.firewall.trustedInterfaces = [ "virbr0" ];
  networking.firewall.checkReversePath = false;
}

