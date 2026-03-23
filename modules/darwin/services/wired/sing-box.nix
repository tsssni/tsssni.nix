{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.services.sing-box;
  settingsFormat = pkgs.formats.json { };
in
{
  options.services.sing-box = {
    enable = lib.mkEnableOption "sing-box universal proxy platform";
    package = lib.mkPackageOption pkgs "sing-box" { };
    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
      };
      default = { };
      description = ''
        The sing-box configuration, see <https://sing-box.sagernet.org/configuration/> for documentation.

        Options containing secret data should be set to an attribute set
        containing the attribute `_secret` - a string pointing to a file
        containing the value the option should be set to.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    launchd.daemons.sing-box =
      let
        collectSecretPaths =
          set:
          if set ? _secret then [ set._secret ]
          else if lib.isDerivation set then [ ]
          else if lib.isAttrs set then lib.concatMap collectSecretPaths (lib.attrValues set)
          else if lib.isList set then lib.concatMap collectSecretPaths set
          else [ ];
        secretPaths = collectSecretPaths cfg.settings;
      in
      {
        script = ''
          mkdir -p /run/sing-box /var/log/sing-box
          /usr/sbin/ipconfig waitall
          ${lib.genJqSecretsScript pkgs cfg.settings "/run/sing-box/config.json"}
          ${lib.getExe cfg.package} -C /run/sing-box run
        '';
        serviceConfig = {
          Label = "org.sagernet.sing-box";
          KeepAlive = {
            PathState = lib.listToAttrs (
              map (path: lib.nameValuePair path true) secretPaths
            );
          };
          RunAtLoad = true;
          StandardOutPath = "/var/log/sing-box/info.log";
          StandardErrorPath = "/var/log/sing-box/error.log";
        };
      };
  };
}
