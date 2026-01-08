{ pkgs, inputs, ... }:

{  
  home-manager.users.zikun = {
    imports = [
      inputs.noctalia.homeModules.default
    ];

    programs.noctalia-shell = {
      enable = true;
      settings = ./noctalia-settings.json;
    };
  };
}
