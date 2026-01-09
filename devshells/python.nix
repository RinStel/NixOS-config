{ pkgs, python ? pkgs.python312 }:
pkgs.mkShell {
  packages = with pkgs; [
    python
    uv
    ruff
    pyright
    git
  ];

  shellHook = ''
    export VIRTUAL_ENV="$PWD/.venv"
    export PATH="$VIRTUAL_ENV/bin:$PATH"

    if [ ! -d "$VIRTUAL_ENV" ]; then
      uv venv "$VIRTUAL_ENV"
    fi
  '';
}
