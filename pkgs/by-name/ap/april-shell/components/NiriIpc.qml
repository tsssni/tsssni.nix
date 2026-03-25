import Quickshell.Io
import QtQuick

Item {
    id: root

    property var workspaces: []
    property var windows: []
    property int focusedWorkspaceId: -1
    property int focusedWindowId: -1

    readonly property var focusedWorkspaceWindows: {
        if (focusedWorkspaceId < 0)
            return [];
        return windows.filter(w => w.workspace_id === focusedWorkspaceId).slice().sort((a, b) => a.layout.pos_in_scrolling_layout[0] - b.layout.pos_in_scrolling_layout[0]);
    }

    function focusWindow(windowId) {
        focusProc.command = ["niri", "msg", "action", "focus-window", "--id", String(windowId)];
        focusProc.running = true;
    }

    visible: false

    Process {
        id: focusProc
        running: false
    }

    Process {
        id: workspacesProc
        command: ["niri", "msg", "--json", "workspaces"]
        running: true
        stdout: SplitParser {
            splitMarker: ""
            onRead: data => {
                try {
                    root.workspaces = JSON.parse(data);
                    for (const ws of root.workspaces)
                        if (ws.is_focused) {
                            root.focusedWorkspaceId = ws.id;
                            break;
                        }
                } catch (e) {}
            }
        }
    }

    Process {
        id: windowsProc
        command: ["niri", "msg", "--json", "windows"]
        running: true
        stdout: SplitParser {
            splitMarker: ""
            onRead: data => {
                try {
                    root.windows = JSON.parse(data);
                    for (const w of root.windows)
                        if (w.is_focused) {
                            root.focusedWindowId = w.id;
                            break;
                        }
                } catch (e) {}
            }
        }
    }

    Process {
        id: eventProc
        command: ["niri", "msg", "--json", "event-stream"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                let event;
                try {
                    event = JSON.parse(data);
                } catch (e) {
                    return;
                }

                if ("WorkspaceActivated" in event && event.WorkspaceActivated.focused)
                    root.focusedWorkspaceId = event.WorkspaceActivated.id;
                if ("WindowFocusChanged" in event) {
                    const newId = event.WindowFocusChanged?.id ?? -1;
                    root.focusedWindowId = newId;
                    root.windows = root.windows.map(w => Object.assign({}, w, {
                            is_focused: w.id === newId
                        }));
                }
                if ("WorkspacesChanged" in event)
                    workspacesProc.running = true;
                if ("WindowOpenedOrChanged" in event || "WindowClosed" in event)
                    windowsProc.running = true;
            }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: {
            workspacesProc.running = true;
            windowsProc.running = true;
        }
    }
}
