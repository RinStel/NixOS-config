let
  # 用户 SSH 公钥 (~/.ssh/id_ed25519.pub)
  zikun = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHfQZrOsIrGwPJwe8Z06tAkxBlOwQd5aftMwC/UWf7YO zikun@forge";

  # 本机 host 公钥 (/etc/ssh/ssh_host_ed25519_key.pub)
  host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGpF0ZS9RdIhV3zxdJTqA5GJqVVdi55+V1fR4YOJ0koL root@nixos";
in
{
  # 文件名要与下面你创建的 *.age 保持一致
  "win11-rdp.age".publicKeys = [ zikun host ];
}

# 使用 `agenix -e *.age` 创建新的密码
