{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.services.sing-box;
  settingsFormat = pkgs.formats.json { };

  recursiveGetAttrWithJqPrefix =
    item: attr:
    let
      recurse =
        prefix: item:
        if item ? ${attr} then
          lib.nameValuePair prefix item.${attr}
        else if lib.isDerivation item then
          [ ]
        else if lib.isAttrs item then
          map (
            name:
            let
              escapedName = ''"${lib.replaceStrings [ ''"'' "\\" ] [ ''\"'' "\\\\" ] name}"'';
            in
            recurse (prefix + "." + escapedName) item.${name}
          ) (lib.attrNames item)
        else if lib.isList item then
          lib.imap0 (index: item: recurse (prefix + "[${toString index}]") item) item
        else
          [ ];
    in
    lib.listToAttrs (lib.flatten (recurse "" item));

  genJqSecretsReplacementSnippet = genJqSecretsReplacementSnippet' "_secret";

  genJqSecretsReplacementSnippet' =
    attr: set: output:
    let
      secrets = recursiveGetAttrWithJqPrefix set attr;
      stringOrDefault = str: def: if str == "" then def else str;
    in
    ''
      if [[ -h '${output}' ]]; then
        rm '${output}'
      fi

      inherit_errexit_enabled=0
      shopt -pq inherit_errexit && inherit_errexit_enabled=1
      shopt -s inherit_errexit
    ''
    + lib.concatStringsSep "\n" (
      lib.imap1 (index: name: ''
        secret${toString index}=$(<'${secrets.${name}}')
        export secret${toString index}
      '') (lib.attrNames secrets)
    )
    + "\n"
    + "${pkgs.jq}/bin/jq >'${output}' "
    + lib.escapeShellArg (
      stringOrDefault (lib.concatStringsSep " | " (
        lib.imap1 (index: name: ''${name} = $ENV.secret${toString index}'') (lib.attrNames secrets)
      )) "."
    )
    + ''
      <<'EOF'
      ${builtins.toJSON set}
      EOF
      (( ! $inherit_errexit_enabled )) && shopt -u inherit_errexit
    '';
in
{
  options.services.sing-box = {
    enable = lib.mkEnableOption (lib.mdDoc "sing-box universal proxy platform");
    package = lib.mkPackageOption pkgs "sing-box" { };
    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
      };
      default = { };
      description = ''
        The sing-box configuration, see https://sing-box.sagernet.org/configuration/ for documentation.

        Options containing secret data should be set to an attribute set
        containing the attribute `_secret` - a string pointing to a file
        containing the value the option should be set to.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    launchd.agents.sing-box =
      let
        script = ''
          ${genJqSecretsReplacementSnippet cfg.settings "/run/sing-box/config.json"}
          ${lib.getExe cfg.package} -C /run/sing-box run
        '';
      in
      {
        serviceConfig = {
          Program = toString (pkgs.writeShellScript "sing-box-wrapper" script);
          ProgramArguments = [ ];
          Label = "org.sagernet.sing-box";
          KeepAlive = true;
          RunAtLoad = true;
          StandardOutPath = "/run/sing-box/info.log";
          StandardErrorPath = "/run/sing-box/error.log";
        };
      };
  };
}
