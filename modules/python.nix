{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Python 开发环境
    python312
    python312Packages.pip
    python312Packages.virtualenv
    uv              # 快速的 pip/venv 替代品
    
    # 开发工具
    ruff            # Python linter/formatter
    pyright         # Python 类型检查
    git
    
    # 原生扩展编译依赖
    pkg-config
    openssl
    zlib
    libffi
    sqlite
    gcc             # 编译器
    gnumake
  ];

  # 确保 OpenSSL 库可被 Python 找到
  environment.variables = {
    LD_LIBRARY_PATH = "${pkgs.openssl.out}/lib:${pkgs.zlib}/lib";
  };
}
