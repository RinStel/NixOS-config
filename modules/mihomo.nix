{ config, pkgs, lib, ... }:
let
  subUrl  = "https://gist.githubusercontent.com/YSC-hain/9eb8ded28f250f9286dd02b4f29d0f52/raw/YSChain's_proxy-3.yaml";
  cfgPath = "/etc/mihomo/config.yaml";
in
{
  services.mihomo = {
    enable = true;
    configFile = cfgPath;
    tunMode = true;
    webui = pkgs.metacubexd;
  };
}
