import Quickshell
import QtQuick

Rectangle {
    id: root

    required property var niriIpc
    required property string output
    readonly property var apps: {
        const ws = niriIpc.workspaces.find(w => w.output === output && w.is_active);
        if (!ws)
            return [];
        return niriIpc.windows.filter(w => w.workspace_id === ws.id).slice().sort((a, b) => {
            const ap = a.layout.pos_in_scrolling_layout;
            const bp = b.layout.pos_in_scrolling_layout;
            return ap[0] - bp[0] || ap[1] - bp[1];
        });
    }

    visible: apps.length > 0
    implicitWidth: 40
    implicitHeight: appsColumn.implicitHeight + 12
    radius: 8
    color: "#303446"
    border.width: 1
    border.color: "#645e8c"

    Column {
        id: appsColumn
        anchors.centerIn: parent
        spacing: 4

        Repeater {
            model: root.apps
            delegate: Item {
                required property var modelData
                width: 32
                height: 32

                Rectangle {
                    anchors.fill: parent
                    radius: 6
                    color: modelData.is_focused ? "#8499d9" : "transparent"
                }

                Image {
                    anchors.centerIn: parent
                    width: 24
                    height: 24
                    source: Quickshell.iconPath(modelData.app_id, true) || "../asset/fluent-ghostty.svg"

                    sourceSize: Qt.size(24, 24)
                    fillMode: Image.PreserveAspectFit
                }
            }
        }
    }
}
