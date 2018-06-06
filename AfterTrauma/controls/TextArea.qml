import QtQuick 2.6
import QtQuick.Controls 2.1

import "../colours.js" as Colours

TextArea {
    height: 48
    color: Colours.veryDarkSlate
    padding: 8
    font.pointSize: 24
    background: Rectangle {
            anchors.fill: parent
            radius: 4
            color: Colours.veryLightSlate
            border.color: "transparent"
        }
}
