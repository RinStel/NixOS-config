{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;

    # 插件兼容优先：FHS 环境（推荐“高度依赖插件”的场景）
    package = pkgs.vscode.fhs;

    # 允许你在 VS Code 里手动安装/更新扩展
    mutableExtensionsDir = true;
  };

  # 可选：Wayland 下更顺
  home.sessionVariables.NIXOS_OZONE_WL = "1";
}
