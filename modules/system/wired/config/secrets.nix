let
  publicKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILFNPSNyxF4pxPj/Q8BsFtz9+nqRqQ7wr2i5X900CXYK"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDcFnJ5t7/Q285EY1+0dsLYfvds9I71SV4U0O7o3qhRy root@tsssni"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAmFVymupgD0GLvBUVcjLvVasA37oErhRDMeuur4FmSR root@deck"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC7CGrFUDso/RBnhrEZUbMK+fGE1xsNdCJ2srZCZ3hqG root@Mac"
  ];
in
{
  "sbx-passwd.age".publicKeys = publicKeys;
  "sbx-server.age".publicKeys = publicKeys;
}
