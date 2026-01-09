{ pkgs, python ? pkgs.python312 }:
pkgs.mkShell {
  packages = [ python pkgs.uv ];
}
