# 使用 agenix 作为密码管理

{ config, ... }:
{
  age.secrets.win11-rdp = {
    file = ./secrets/win11-rdp.age;

    # 让用户脚本可读
    owner = "zikun";
    group = "users";
    mode  = "0400";
  };
}
