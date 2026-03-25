import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

PanelWindow {
    id: root
    visible: false
    anchors {
        right: true
    }

    function toggle(): void {
        if (!visible) {
            card.opacity = 0;
            card.slideX = 20;
            visible = true;
            showAnim.start();
            if (card.artUrl)
                colorSampler.loadImage(card.artUrl);
        } else {
            hideAnim.start();
        }
    }

    SequentialAnimation {
        id: showAnim
        ParallelAnimation {
            NumberAnimation {
                target: card
                property: "opacity"
                to: 1
                duration: 200
                easing.type: Easing.OutCubic
            }
            NumberAnimation {
                target: card
                property: "slideX"
                to: 0
                duration: 200
                easing.type: Easing.OutCubic
            }
        }
    }

    SequentialAnimation {
        id: hideAnim
        ParallelAnimation {
            NumberAnimation {
                target: card
                property: "opacity"
                to: 0
                duration: 150
                easing.type: Easing.InCubic
            }
            NumberAnimation {
                target: card
                property: "slideX"
                to: 20
                duration: 150
                easing.type: Easing.InCubic
            }
        }
        ScriptAction {
            script: root.visible = false
        }
    }

    implicitWidth: 256
    implicitHeight: 256
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
    color: "transparent"

    Item {
        id: card
        anchors.fill: parent
        focus: true
        property real slideX: 0
        transform: Translate {
            x: card.slideX
        }

        readonly property list<MprisPlayer> players: Mpris.players.values
        readonly property MprisPlayer player: players.find(p => p.identity === "musicfox" && p.playbackState === MprisPlaybackState.Playing) ?? players.find(p => p.identity === "musicfox") ?? null
        readonly property string title: player?.trackTitle ?? ""
        readonly property string artist: player?.trackArtist ?? ""
        readonly property string artUrl: player?.trackArtUrl ?? ""
        property string displayArtUrl: ""
        property color textColor: "#bebad9"

        onArtUrlChanged: {
            if (artUrl) {
                colorSampler.loadImage(artUrl);
                coverAnim.restart();
            }
        }

        SequentialAnimation {
            id: coverAnim
            NumberAnimation {
                target: coverItem
                property: "opacity"
                to: 0
                duration: 300
                easing.type: Easing.InCubic
            }
            ScriptAction {
                script: card.displayArtUrl = card.artUrl
            }
            NumberAnimation {
                target: coverItem
                property: "opacity"
                to: 1
                duration: 400
                easing.type: Easing.OutCubic
            }
        }

        Keys.onPressed: event => {
            if (!player)
                return;
            switch (event.key) {
            case Qt.Key_Space:
                player.togglePlaying();
                break;
            case Qt.Key_J:
                player.next();
                break;
            case Qt.Key_K:
                player.previous();
                break;
            }
            event.accepted = true;
        }

        readonly property real blurRadius: 32

        Item {
            id: bgImage
            anchors.centerIn: parent
            width: parent.width + card.blurRadius * 2
            height: parent.height + card.blurRadius * 2
            visible: false

            Rectangle {
                anchors.fill: parent
                color: "#303446"
            }

            Image {
                anchors.fill: parent
                source: card.displayArtUrl
                fillMode: Image.PreserveAspectCrop
            }
        }

        GaussianBlur {
            id: blurEffect
            anchors.centerIn: parent
            width: card.width + card.blurRadius * 2
            height: card.height + card.blurRadius * 2
            source: bgImage
            radius: card.blurRadius
            samples: card.blurRadius * 2 + 1
        }

        Canvas {
            id: colorSampler
            width: 64
            height: 64
            visible: false

            onImageLoaded: requestPaint()

            onPaint: {
                if (!card.artUrl)
                    return;
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);
                ctx.drawImage(card.artUrl, 0, 0, width, height);

                var c = [0, 0, 0];
                for (var y = 48; y < 64; y++)
                    for (var x = 16; x < 48; x++) {
                        var d = ctx.getImageData(x, y, 1, 1).data;
                        for (var i = 0; i < 3; i++)
                            c[i] += (d[i] / 255.0) * (d[i] / 255.0);
                    }
                for (var i = 0; i < 3; i++)
                    c[i] /= 512;
                // WCAG relative luminance (already in linear space)
                var luma = 0.2126 * c[0] + 0.7152 * c[1] + 0.0722 * c[2];
                // threshold ≈ 0.179 maximises minimum contrast ratio with black/white
                card.textColor = luma < 0.179 ? "#bebad9" : "#1a1730";
            }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 8

            Item {
                Layout.fillHeight: true
            }

            Item {
                id: coverItem
                Layout.preferredWidth: 160
                Layout.preferredHeight: 160
                Layout.alignment: Qt.AlignHCenter

                Rectangle {
                    anchors.fill: parent
                    color: "#303446"
                }

                Image {
                    anchors.fill: parent
                    source: card.displayArtUrl
                    fillMode: Image.PreserveAspectCrop
                }

                layer.enabled: true
                layer.effect: OpacityMask {
                    cached: true
                    maskSource: Rectangle {
                        width: 160
                        height: 160
                        radius: 8
                    }
                }
            }

            Text {
                Layout.fillWidth: true
                text: card.title
                color: card.textColor
                font.pixelSize: 16
                font.bold: true
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                Layout.fillWidth: true
                text: card.artist
                color: card.textColor
                font.pixelSize: 14
                font.bold: true
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignHCenter
            }

            Item {
                Layout.fillHeight: true
            }
        }

        layer.enabled: true
        layer.effect: OpacityMask {
            cached: true
            maskSource: Rectangle {
                width: card.width
                height: card.height
                radius: 12
            }
        }
    }
}
