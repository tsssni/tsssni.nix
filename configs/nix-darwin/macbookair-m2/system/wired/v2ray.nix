{
  config
, ...
}:
{
  age.secrets."v2ray.json" = {
    file = ./config/v2ray.json.age;
    mode = "444";
  };
  services.v2ray = {
    enable = true;
    configFile = config.age.secrets."v2ray.json".path;
  };
}
