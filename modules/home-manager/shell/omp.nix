{
  lib
, config
, ...
}:
let
	cfg = config.tsssni.omp;
in with lib; {
	options.tsssni.omp = {
		enable = mkEnableOption "tsssni.omp";
	};

	config = mkIf cfg.enable {
		programs.oh-my-posh = {
			enable = true;
			settings = {
				blocks = [
					{
						alignment = "left";
						newline = true;
						segments = [
							{
								background = "#f8f8ff";
								foreground = "#333333";
								leading_diamond = "";
								properties.macos = "󱄅 ";
								style = "diamond";
								template = "";
								trailing_diamond = "<transparent,#f8f8ff></>";
								type = "os";
							}
							{
								background = "#f8f8ff";
								foreground = "#333333";
								leading_diamond = "";
								style = "diamond";
								template = "  {{ .Name }}";
								trailing_diamond = "<transparent,#f8f8ff></>";
								type = "shell";
							}
							{
								background = "#4685ea";
								foreground = "#f8f8ff";
								leading_diamond = "";
								style = "diamond";
								template = "  MEM: {{ round .PhysicalPercentUsed .Precision }}% | {{ (div ((sub .PhysicalTotalMemory .PhysicalAvailableMemory)|float64) 1073741824.0) }}/{{ (div .PhysicalTotalMemory 1073741824.0) }}GB  ";
								trailing_diamond = "<transparent,#4685ea></>";
								type = "sysinfo";
							}
							{
								background = "#333333";
								foreground = "#777777";
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
								background = "#bef743";
								foreground = "#333333";
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
								foreground = "#777777";
								style = "plain";
								template = "╭─";
								type = "text";
							}
							{
								foreground = "#777777";
								properties = {
									time_format = "15:04";
								};
								style = "plain";
								template = " ♥ {{ .CurrentDate | date .Format }} |";
								type = "time";
							}
							{
								foreground = "#777777";
								style = "plain";
								template = "  ";
								type = "root";
							}
							{
								foreground = "#777777";
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
								foreground = "#777777";
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
					foreground = "#f8f8ff";
					template = " ";
				};
				version = 2;
			};
		};
	};
}
