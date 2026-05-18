{ ... }:
{
  tsssni.proxy = {
    enable = true;
    domain = "tsssni.top";
    email = "dingyongyu2002@foxmail.com";
    hostName = "gkms";
    address = [ "102.134.49.99/24" ];
    gateway = [ "102.134.49.1" ];
    passwd = ../../../../assets/proxy/passwd.age;
    cloudflareApiToken = ../../../../assets/proxy/cloudflare.age;
  };
}
