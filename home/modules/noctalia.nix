{ inputs, lib, pkgs, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  home.packages = with pkgs; [
    gpu-screen-recorder
    gpu-screen-recorder-gtk
  ];

  programs.noctalia-shell.enable = true;

  xdg.configFile."noctalia/settings.seed.json".source = ./noctalia-settings.json;
  xdg.configFile."noctalia/plugins.seed.json".source = ./noctalia-plugins.json;

  home.activation.noctaliaWritableState =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      cfg="$HOME/.config/noctalia"
      mkdir -p "$cfg"

      seed_file() {
        seed="$1"
        target="$2"

        if [ -L "$target" ]; then
          rm -f "$target"
        fi

        if [ ! -e "$target" ]; then
          cp "$seed" "$target"
        fi
      }

      seed_file "$cfg/settings.seed.json" "$cfg/settings.json"
      seed_file "$cfg/plugins.seed.json" "$cfg/plugins.json"
    '';
}
