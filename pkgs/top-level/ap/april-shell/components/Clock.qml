import QtQuick
import QtQuick.Layouts

RowLayout {
    id: clock

    property string hours: ""
    property string minutes: ""

    spacing: 4

    function update() {
        const now = new Date();
        hours = now.getHours().toString().padStart(2, "0");
        minutes = now.getMinutes().toString().padStart(2, "0");
        hours = hours.split('').join('\n');
        minutes = minutes.split('').join('\n');
    }

    Component.onCompleted: update()

    Timer {
        interval: 60000
        running: true
        repeat: true
        onTriggered: clock.update()
    }

    component ClockText: Text {
        Layout.alignment: Qt.AlignVCenter
        font.pixelSize: 22
        font.bold: true
        font.family: "IBM Plex Mono"
        lineHeightMode: Text.FixedHeight
        lineHeight: font.pixelSize
    }

    ClockText {
        text: clock.minutes
        color: "#c0a8e8"
    }

    ClockText {
        text: clock.hours
        color: "#9fe5e5"
    }
}
