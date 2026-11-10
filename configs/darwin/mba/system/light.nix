{
  pkgs,
  ...
}:
let
  inherit (pkgs.qt6) qt-prune;

  qtbase =
    qt-prune pkgs.qt6.qtbase
      [ "lib/qt-6/plugins/{printsupport,sqldrivers}" ]
      [
        "Core"
        "DBus"
        "Gui"
        "Network"
        "OpenGL"
        "Widgets"
      ];
  qtdeclarative =
    qt-prune pkgs.qt6.qtdeclarative
      [
        "lib/qt-6/plugins/qmltooling"
        "lib/qt-6/qml/QtTest"
        "lib/qt-6/qml/QtQuick/{LocalStorage,tooling}"
      ]
      [
        "Qml"
        "QmlMeta"
        "QmlModels"
        "QmlWorkerScript"
        "Quick"
        "QuickControls2"
        "QuickLayouts"
        "QuickTemplates2"
      ];
in
{
  tsssni.infra.light = with pkgs; {
    enable = true;
    replace = {
      boost189 = boost189_1;
      gettext = gettext-runtime;
      ncurses = ncurses-alacritty;
    };
    scopes.qt6 = { inherit qtbase qtdeclarative; };
  };
}
