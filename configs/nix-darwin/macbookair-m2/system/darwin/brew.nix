{ ... }:
{
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "uninstall";
      autoUpdate = true;
      upgrade = true;
    };
    casks = [
      "qq"
      "wechat"
      "lark"
      "dingtalk"
      "tencent-meeting"
      "wpsoffice"
    ];
    masApps = {
      Keynote = 409183694;
      Pages = 409201541;
      Numbers = 409203825;
    };
  };
}
