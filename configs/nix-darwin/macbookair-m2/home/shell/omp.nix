{ ... }:
{
  programs.oh-my-posh = {
    enable = true;
    settings = {
      blocks = [
        {
          alignment = "left";
          newline = true;
          segments = [
            {
              background = "#FEF5ED";
              foreground = "#011627";
              leading_diamond = "";
              properties.macos = " ";
              style = "diamond";
              template = "";
              trailing_diamond = "<transparent,#FEF5ED></>";
              type = "os";
            }
            {
              background = "#FEF5ED";
              foreground = "#011627";
              leading_diamond = "";
              style = "diamond";
              template = "  {{ .Name }}";
              trailing_diamond = "<transparent,#FEF5ED></>";
              type = "shell";
            }
            {
              background = "#516BEB";
              foreground = "#ffffff";
              leading_diamond = "";
              style = "diamond";
              template = "  MEM: {{ round .PhysicalPercentUsed .Precision }}% | {{ (div ((sub .PhysicalTotalMemory .PhysicalAvailableMemory)|float64) 1073741824.0) }}/{{ (div .PhysicalTotalMemory 1073741824.0) }}GB  ";
              trailing_diamond = "<transparent,#516BEB></>";
              type = "sysinfo";
            }
            {
              background = "#575656";
              foreground = "#d6deeb";
              leading_diamond = "";
              properties = {
                style = "roundrock";
                threshold = 0;
              };
              style = "diamond";
              template = " {{ .FormattedMs }} ";
              trailing_diamond = "";
              type = "executiontime";
            }
          ];
          type = "prompt";
        }
        {
          alignment = "right";
          segments = [
            {
              background = "#17D7A0";
              foreground = "#011627";
              leading_diamond = "";
              properties = {
                branch_icon = " ";
                fetch_stash_count = true;
                fetch_status = true;
                fetch_upstream_icon = true;
                fetch_worktree_count = true;
              };
              style = "diamond";
              template = " {{ .UpstreamIcon }}{{ .HEAD }}{{if .BranchStatus }} {{ .BranchStatus }}{{ end }}{{ if .Working.Changed }}  {{ .Working.String }}{{ end }}{{ if and (.Working.Changed) (.Staging.Changed) }} |{{ end }}{{ if .Staging.Changed }}  {{ .Staging.String }}{{ end }}{{ if gt .StashCount 0 }}  {{ .StashCount }}{{ end }} ";
              trailing_diamond = "";
              type = "git";
            }
          ];
          type = "prompt";
        }
        {
          alignment = "left";
          newline = true;
          segments = [
            {
              style = "plain";
              template = "╭─";
              type = "text";
            }
            {
              properties = {
                time_format = "15:04";
              };
              style = "plain";
              template = " ♥ {{ .CurrentDate | date .Format }} |";
              type = "time";
            }
            {
              style = "plain";
              template = "  ";
              type = "root";
            }
            {
              properties = {
                folder_icon = " ";
                folder_separator_icon = "  ";
                home_icon = " ";
              };
              style = "plain";
              template = " {{ .Path }} ";
              type = "path";
            }
          ];
          type = "prompt";
        }
        {
          alignment = "left";
          newline = true;
          segments = [
            {
              properties.always_enabled = true;
              style = "plain";
              template = "╰─ ";
              type = "status";
            }
          ];
          type = "prompt";
        }
      ];
      console_title_template = "{{ .Folder }}";
      transient_prompt = {
        background = "transparent";
        foreground = "#FEF5ED";
        template = " ";
      };
      version = 2;
    };
    enableZshIntegration = true;
  };
}
