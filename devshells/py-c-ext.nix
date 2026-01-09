{ pkgs, python ? pkgs.python312 }:
pkgs.mkShell {
  packages = with pkgs; [
    python
    uv
    ruff
    pyright
    git

    # 编译/链接常用
    pkg-config
    gcc
    gnumake

    # 常见 Python 包会用到
    openssl
    zlib
    libffi
    sqlite
  ];

  shellHook = ''
    export VIRTUAL_ENV="$PWD/.venv"
    export PATH="$VIRTUAL_ENV/bin:$PATH"

    if [ ! -d "$VIRTUAL_ENV" ]; then
      uv venv "$VIRTUAL_ENV"
    fi
  '';
}
