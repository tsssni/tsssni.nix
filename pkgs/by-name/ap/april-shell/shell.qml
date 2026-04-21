import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import "components"

ShellRoot {
    id: root

    PanelWindow {
        id: bar
        anchors {
            top: true
            right: true
            bottom: true
        }

        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
        WlrLayershell.namespace: "april-shell"
        exclusionMode: ExclusionMode.Auto
        implicitWidth: 48
        color: "#cc303446"

        Column {
            id: topSection
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 8
            spacing: 8

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                source: "asset/nix.svg"
                sourceSize.width: 40
                sourceSize.height: 40
            }

            Workspace {
                anchors.horizontalCenter: parent.horizontalCenter
                niriIpc: niriIpc
            }
        }

        Clock {
            id: clockSection
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 8
        }

        MiniPlayer {
            id: miniPlayer
            anchors.centerIn: parent
            onClicked: blurryPlayer.toggle()
        }
    }

    NiriIpc {
        id: niriIpc
    }

    BlurryPlayer {
        id: blurryPlayer
        anchors.top: true
        anchors.right: true
        margins.right: bar.implicitWidth + 4
        margins.top: Math.max(0, bar.height / 2 - implicitHeight / 2)
    }

    IpcHandler {
        target: "toggleBlurryPlayer"
        function toggle(): void {
            blurryPlayer.toggle();
        }
    }
}
