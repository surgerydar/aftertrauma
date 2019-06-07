import QtQuick 2.6
import QtQuick.Controls 2.1

import "../colours.js" as Colours

TextField {
    height: 48
    color: Colours.veryDarkSlate
    font.pointSize: 24
    background: Rectangle {
        id: background
        anchors.fill: parent
        radius: 4
        color: Colours.veryLightSlate
        border.color: "transparent"
    }
    property alias backgroundColour: background.color
}
