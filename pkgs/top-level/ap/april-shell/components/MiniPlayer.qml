import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Effects

Item {
    id: root

    readonly property var musicfoxPlayers: Mpris.players.values.filter(p => p.identity === "musicfox")
    readonly property MprisPlayer player: musicfoxPlayers.find(p => p.playbackState === MprisPlaybackState.Playing) ?? musicfoxPlayers[0] ?? null

    function parseLrc(text) {
        if (!text) return []
        var lines = text.split('\n')
        var result = []
        for (var i = 0; i < lines.length; i++) {
            var m = lines[i].match(/\[(\d{2}):(\d{2})[.:](\d{2,3})\](.*)/)
            if (!m) continue
            var mins = parseInt(m[1])
            var secs = parseInt(m[2])
            var frac = parseInt(m[3]) / (m[3].length === 2 ? 100 : 1000)
            var txt = m[4].trim()
            if (txt) result.push({ time: mins * 60 + secs + frac, text: txt })
        }
        return result
    }

    readonly property var lyrics: {
        var meta = player ? player.metadata : null
        return parseLrc(meta ? (meta["xesam:asText"] ?? "") : "")
    }

    property int currentLyricIndex: 0
    property real lyricProgress: 0.0
    property real displayProgress: 0.0

    property string displayPrev: ""
    property string displayCurrent: ""
    property string displayNext: ""

    property int maxLength: 1024

    component ContextText: Text {
        color: "#606878"
        font.pixelSize: 14
        font.italic: true
        font.family: "IBM Plex Mono"
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
    }

    component CurrentText: Text {
        font.pixelSize: 20
        font.italic: true
        font.family: "IBM Plex Mono"
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
    }

    onLyricsChanged: {
        currentLyricIndex = 0
        lyricProgress = 0.0
        displayProgress = 0.0
        lyricChangeAnim.restart()
    }
    onCurrentLyricIndexChanged: lyricChangeAnim.restart()

    SequentialAnimation {
        id: lyricChangeAnim
        ParallelAnimation {
            NumberAnimation {
                target: lyricsContainer
                property: "opacity"
                to: 0
                duration: 200
                easing.type: Easing.InCubic
            }
            NumberAnimation {
                target: root
                property: "displayProgress"
                to: 1.0
                duration: 200
                easing.type: Easing.OutCubic
            }
        }
        ScriptAction {
            script: {
                root.displayPrev = root.prevLyric
                root.displayCurrent = root.currentLyric
                root.displayNext = root.nextLyric
                root.displayProgress = 0
            }
        }
        NumberAnimation {
            target: lyricsContainer
            property: "opacity"
            to: 1
            duration: 300
            easing.type: Easing.OutCubic
        }
    }

    function updateCurrentLyric() {
        if (lyrics.length === 0 || !player) return
        var pos = player.position
        var idx = 0
        for (var i = 0; i < lyrics.length; i++) {
            if (lyrics[i].time <= pos) idx = i
            else break
        }
        currentLyricIndex = idx
        var startTime = lyrics[idx].time
        var endTime = idx < lyrics.length - 1 ? lyrics[idx + 1].time : startTime + 5
        lyricProgress = Math.max(0.0, Math.min(1.0, (pos - startTime) / (endTime - startTime)))
        if (!lyricChangeAnim.running) {
            var diff = lyricProgress - displayProgress
            if (Math.abs(diff) > 0.01)
                displayProgress = displayProgress + diff * 0.15
            else
                displayProgress = lyricProgress
        }
    }

    Timer {
        interval: 32
        repeat: true
        running: root.player !== null
        onTriggered: root.updateCurrentLyric()
    }

    readonly property string prevLyric: lyrics.length > 0 && currentLyricIndex > 0 ? lyrics[currentLyricIndex - 1].text : ""
    readonly property string currentLyric: lyrics.length > 0 ? lyrics[currentLyricIndex].text : (player?.trackTitle ?? "")
    readonly property string nextLyric: lyrics.length > 0 && currentLyricIndex < lyrics.length - 1 ? lyrics[currentLyricIndex + 1].text : ""
    readonly property string longerContext: displayPrev.length > displayNext.length ? displayPrev : displayNext

    onCurrentLyricChanged: {
        if (displayCurrent === "" && currentLyric !== "") {
            displayPrev = prevLyric
            displayCurrent = currentLyric
            displayNext = nextLyric
        }
    }

    TextMetrics {
        id: metricsCurrent
        font.pixelSize: 20
        font.italic: true
        font.family: "IBM Plex Mono"
        text: root.displayCurrent
    }

    TextMetrics {
        id: metricsContext
        font.pixelSize: 14
        font.italic: true
        font.family: "IBM Plex Mono"
        text: root.longerContext
    }

    readonly property int lineHeight: Math.ceil(metricsCurrent.height)
    readonly property int contextHeight: Math.ceil(metricsContext.height)
    readonly property int lyricsStripWidth: contextHeight + 4 + lineHeight + 4 + contextHeight
    readonly property int titleVisualHeight: Math.min(maxLength, Math.max(Math.ceil(metricsCurrent.width), Math.ceil(metricsContext.width)) + 16)

    visible: player !== null
    implicitWidth: lyricsStripWidth + 4
    implicitHeight: titleVisualHeight

    signal clicked

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }

    Item {
        anchors.centerIn: parent
        width: root.lyricsStripWidth
        height: root.titleVisualHeight
        clip: true

        Item {
            id: lyricsContainer
            width: root.titleVisualHeight
            height: root.lyricsStripWidth
            anchors.centerIn: parent
            rotation: 90

            ContextText {
                x: 0; y: 0
                width: root.titleVisualHeight
                height: root.contextHeight
                text: root.displayPrev
            }

            CurrentText {
                id: currentLyricGray
                x: 0
                y: root.contextHeight + 4
                width: root.titleVisualHeight
                height: root.lineHeight
                text: root.displayCurrent
                color: "#606878"
            }

            Item {
                x: 0
                y: root.contextHeight + 4
                width: root.titleVisualHeight * root.displayProgress
                height: root.lineHeight
                clip: true

                Rectangle {
                    id: currentGradient
                    x: 0
                    y: 0
                    width: root.titleVisualHeight
                    height: root.lineHeight
                    layer.enabled: true
                    visible: false
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: "#a0b4e5" }
                        GradientStop { position: 1.0; color: "#a8e5af" }
                    }
                }

                CurrentText {
                    id: currentLyricText
                    x: 0
                    y: 0
                    width: root.titleVisualHeight
                    height: root.lineHeight
                    text: root.displayCurrent
                    layer.enabled: true
                    visible: false
                }

                MultiEffect {
                    x: 0
                    y: 0
                    width: root.titleVisualHeight
                    height: root.lineHeight
                    source: currentGradient
                    maskEnabled: true
                    maskSource: currentLyricText
                }
            }

            ContextText {
                x: 0
                y: root.contextHeight + 4 + root.lineHeight + 4
                width: root.titleVisualHeight
                height: root.contextHeight
                text: root.displayNext
            }
        }
    }
}
