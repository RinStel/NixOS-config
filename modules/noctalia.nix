{ pkgs, inputs, lib, ... }:

{  
  home-manager.users.zikun = { config, pkgs, lib, ... }: {
    imports = [
      inputs.noctalia.homeModules.default
    ];

    programs.noctalia-shell = {
      enable = true;
    };

    # 把“种子配置”放到 XDG 里
    xdg.configFile."noctalia/settings.seed.json".source = ./noctalia-settings.json;

    # 激活时：确保 settings.json 是普通可写文件，并在首次创建时从 seed 复制
    home.activation.noctaliaSeedSettings =
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        cfg="$HOME/.config/noctalia"
        mkdir -p "$cfg"

        seed="$cfg/settings.seed.json"
        target="$cfg/settings.json"

        # 如果历史上被 HM 做成 symlink（只读），先还原成普通文件
        if [ -L "$target" ]; then
          rm -f "$target"
        fi

        # 只在首次生成时写入默认值；之后交给 Noctalia 自己改
        if [ ! -e "$target" ]; then
          cp "$seed" "$target"
        fi
      '';
  };
}
