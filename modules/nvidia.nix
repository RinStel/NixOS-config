{ config, pkgs, ... }:

{
  # 启用 NVIDIA 驱动
  hardware.graphics.enable = true;
  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;
    powerManagement.enable = true; #休眠后唤醒不会花屏
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia-container-toolkit.enable = true;

  /*
  # CUDA 部分
  environment.systemPackages = with pkgs; [
    cudatoolkit
    cudaPackages.cuda_nvcc      # nvcc 编译器
    cudaPackages.cudnn          # 可选：cuDNN
    # 其它可能的 CUDA 包
  ];

  environment.variables = {
    CUDA_PATH = "${pkgs.cudatoolkit}";
    LD_LIBRARY_PATH = "${pkgs.cudatoolkit}/lib:${pkgs.cudaPackages.cuda_nvcc}/lib";
  };
  */
  nixpkgs.config = {
    cudaSupport = false;  # 让包构建时启用 CUDA 支持
  };
}
