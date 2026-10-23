pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import QtQuick
import "components"

ShellRoot {
    id: root

    NiriIpc {
        id: niriIpc
    }

    Variants {
        model: Quickshell.screens

        Scope {
            id: barScope
            required property var modelData
            readonly property string screenName: modelData.name

            PanelWindow {
                id: bar
                screen: barScope.modelData

                anchors {
                    top: true
                    right: true
                    bottom: true
                }

                WlrLayershell.layer: WlrLayer.Top
                WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
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
                }
            }
        }
    }
}
