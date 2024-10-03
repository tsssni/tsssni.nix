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
    ];
    masApps = {
      Xcode = 497799835;
      Keynote = 409183694;
      Pages = 409201541;
      Numbers = 409203825;
    };
  };
}
