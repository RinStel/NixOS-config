{ ... }:

{
  systemd.services.komari-agent = {
    description = "Komari Agent Service";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "/opt/komari/agent -e https://tz.yschain.top -t 6poLGtr242yfFnpUlqm2oO --disable-web-ssh --include-nics eno1,wlp14s0";
      WorkingDirectory = "/opt/komari";
      Restart = "always";
      User = "root";
    };
  };
}
