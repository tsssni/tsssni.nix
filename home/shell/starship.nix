{ ... }:
{
  programs.starship = {
    enable = true;
    settings = {
      format =
        "[ ░▒▓](#7ff5f5)" +
        "[ NIX ](fg:#333333 bg:#7ff5f5)" +
        "[](fg:#7ff5f5 bg:#4685ea)" +
        "$directory" +
        "[](fg:#4685ea bg:#a8a8ff)" +
        "$git_branch" +
        "$git_status" +
        "[](fg:#a8a8ff bg:#ff6699)" +
        "$golang" +
        "[](fg:#ff6699 bg:#f5c1e9)" +
        "$time" +
        "[ ](fg:#f5c1e9)" +
        "\n $character"
      ;
      directory = {
        format = "[ $path ](fg:#fccb2e bg:#4685ea)";
        truncation_length = 1;
      };
      git_branch = {
        symbol = "";
        format = "[ $symbol $branch ](fg:#8b4efc bg:#a8a8ff)";
      };
      git_status = {
        format = "[($all_status$ahead_behind )](fg:#8b4efc bg:#a8a8ff)";
      };
      golang = {
        symbol = "MyGO";
        format = "[ $symbol:=$version!!!!!](fg:#f5c1e9 bg:#ff6699)";
      };
      time = {
        disabled = false;
        time_format = "%R"; # Hour:Minute Format
        style = "bg:#1d2230";
        format = "[  $time ](fg:#ff0055 bg:#f5c1e9)";
      };
      character.format = "[> ](#00ffc8)";
    };
  };
}
