import QtQuick 2.6
import QtQuick.Controls 2.1

import "colours.js" as Colours

Rectangle {
    id: badge
    height: 24
    width: Math.max( height, badgeText.contentWidth + height / 2 )
    radius: height / 2
    color: Colours.red
    visible: badgeText.text.length > 0
    //
    //
    //
    Label {
        id: badgeText
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.centerIn: parent
        verticalAlignment: Label.AlignVCenter
        horizontalAlignment: Label.AlignHCenter
        font.pointSize: 12
        color: Colours.almostWhite

    }
    //
    //
    //
    property alias text: badgeText.text
}
