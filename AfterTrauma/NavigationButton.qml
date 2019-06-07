import QtQuick 2.0
import QtQuick.Controls 2.1

import "colours.js" as Colours

Item {
    id: container
    opacity: enabled ? 1. : .5
    //
    //
    //
    property alias icon: iconImage.source
    property alias label: labelText.text
    property alias badge: badge.text
    //
    //
    //
    signal clicked();
    //
    //
    //
    Image {
        id: iconImage
        anchors.fill: container
        anchors.bottomMargin: labelText.height
        anchors.margins: 8
        fillMode: Image.PreserveAspectFit
    }
    //
    //
    //
    Label {
        id: labelText
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        horizontalAlignment: Text.AlignHCenter
        font.weight: Font.Light
        font.family: fonts.light
        font.pointSize: 12
        color: Colours.almostWhite
    }
    //
    //
    //
    NumberBadge {
        id: badge
        height: iconImage.height / 2
        anchors.top: iconImage.top
        anchors.right: iconImage.right
        anchors.rightMargin: ( iconImage.width - iconImage.paintedWidth ) / 2.
    }
    //
    //
    //
    MouseArea {
        anchors.fill: parent
        onClicked: {
            container.clicked();
        }
    }
}
