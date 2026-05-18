let
  publicKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEICEtnLynz9s0geg0N4v5acIFBpMPfrn7yAeAKnzUbu root@blak"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO4lc5BaXTfrdPCcfA8scGgR3G7XNnOb/qrqkBqWBVML root@gkms"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINs7JUeKdbtr8B1tAdyNIlRjedkVreAtKERKvAb4ltAq dingyongyu2002@foxmail.com"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJax0Eo+863xqIl7cHSAQKY8NP/cK3ea8R6OiIUWCtzT dingyongyu2002@foxmail.com"
  ];
in
{
  "passwd.age".publicKeys = publicKeys;
  "cloudflare.age".publicKeys = publicKeys;
}
