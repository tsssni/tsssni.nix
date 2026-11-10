{
  pkgs,
  config,
  ...
}:
let
  inherit (pkgs.qt6) qt-prune;

  qtbase =
    qt-prune pkgs.qt6.qtbase
      [
        "lib/qt-6/plugins/{egldeviceintegrations,generic,networkinformation,platforminputcontexts,printsupport,sqldrivers,tls,wayland-decoration-client,xcbglintegrations}"
        "lib/qt-6/plugins/imageformats/libq{gif,ico,jpeg}.so"
        "lib/qt-6/plugins/platforms/lib{qeglfs,qlinuxfb,qminimal,qminimalegl,qoffscreen,qvkkhrdisplay,qvnc,qxcb}.so"
        "lib/qt-6/plugins/platformthemes/libqxdgdesktopportal.so"
        "lib/qt-6/plugins/wayland-graphics-integration-client/lib{dmabuf,drm-egl,shm-emulation,vulkan}-server.so"
        "lib/qt-6/plugins/wayland-shell-integration/lib{fullscreen-shell-v1,wl-shell-plugin}.so"
      ]
      [
        "Core"
        "DBus"
        "Gui"
        "Network"
        "OpenGL"
        "WaylandClient"
        "Widgets"
      ];
  qtdeclarative =
    qt-prune pkgs.qt6.qtdeclarative
      [
        "lib/qt-6/plugins"
        "lib/qt-6/qml/{QML,QmlTime,Qt,QtCore,QtNetwork,QtTest}"
        "lib/qt-6/qml/QtQml/{DesignSupport,XmlListModel}"
        "lib/qt-6/qml/QtQuick/{Controls,Dialogs,Layouts,LocalStorage,Particles,Shapes,Templates,tooling,VectorImage}"
      ]
      [
        "Qml"
        "QmlMeta"
        "QmlModels"
        "QmlWorkerScript"
        "Quick"
        "QuickEffects"
      ];
in
{
  tsssni.infra.light = with pkgs; {
    enable = true;
    replace = {
      boost189 = boost189_1;
      gettext = gettext-runtime;
      glibc = glibc-utf8;
      gtk3 = gtk3_1;
      hwdata = hwdata-lan;
      icu = icu-en;
      iproute2 = iproute-wired;
      "libpcap.lib" = libpcap-plain.lib;
      ncurses = ncurses-alacritty;
      pipewire = pipewire-direct;
      python3 = python3-convex;
      systemd = config.systemd.package;
      systemdMinimal = systemd-minimal-lean;
      xdg-utils = xdg-utils-perless;
    };
    scopes.qt6 = { inherit qtbase qtdeclarative; };
    clear = [ qt6.qttranslations ];
    core = [
      cpio
      gnupatch
      host
      mkpasswd
      netcat
      time
    ];
  };
}
