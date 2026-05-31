pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import "components"

ShellRoot {
    id: root

    NiriIpc {
        id: niriIpc
    }

    Variants {
        id: bars
        model: Quickshell.screens

        Scope {
            id: barScope
            required property var modelData
            readonly property string screenName: modelData.name
            property alias player: blurryPlayer

            PanelWindow {
                id: bar
                screen: barScope.modelData

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
                        output: barScope.screenName
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
                    visible: barScope.screenName === niriIpc.focusedOutput
                    onClicked: blurryPlayer.toggle()
                }
            }

            BlurryPlayer {
                id: blurryPlayer
                screen: barScope.modelData
                anchors.top: true
                anchors.right: true
                margins.right: bar.implicitWidth + 4
                margins.top: Math.max(0, bar.height / 2 - implicitHeight / 2)
            }
        }
    }

    IpcHandler {
        target: "toggleBlurryPlayer"
        function toggle(): void {
            for (const i of bars.instances)
                if (i.screenName === niriIpc.focusedOutput)
                    i.player.toggle();
        }
    }
}
