import Quickshell
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    required property var niriIpc
    readonly property var apps: niriIpc.focusedWorkspaceWindows

    visible: apps.length > 0
    implicitWidth: 40
    implicitHeight: appsColumn.implicitHeight + 12
    radius: 8
    color: "#303446"
    border.width: 1
    border.color: "#645e8c"

    ColumnLayout {
        id: appsColumn
        anchors.centerIn: parent
        spacing: 4

        Repeater {
            model: root.apps
            delegate: Item {
                required property var modelData
                Layout.preferredWidth: 32
                Layout.preferredHeight: 32
                Layout.alignment: Qt.AlignHCenter

                Rectangle {
                    anchors.fill: parent
                    radius: 6
                    color: modelData.is_focused ? "#8499d9" : "transparent"
                }

                Image {
                    id: icon
                    anchors.centerIn: parent
                    width: 24
                    height: 24
                    source: Quickshell.iconPath(modelData.app_id, true) || "../asset/fluent-ghostty.svg"

                    sourceSize: Qt.size(24, 24)
                    fillMode: Image.PreserveAspectFit
                    scale: hoverArea.containsMouse ? 1.3 : 1.0

                    Behavior on scale {
                        NumberAnimation {
                            duration: 150
                            easing.type: Easing.OutCubic
                        }
                    }
                }

                MouseArea {
                    id: hoverArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.niriIpc.focusWindow(modelData.id)
                }
            }
        }
    }
}
