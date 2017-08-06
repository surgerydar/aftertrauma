import QtQuick 2.6
import QtQuick.Controls 2.1

import "../colours.js" as Colours

Item {
    id: container
    //
    //
    //
    height: Math.max(64,content.height + 16)
    //
    //
    //
    Background {
        anchors.fill: parent
        fill: Colours.almostWhite
        radius: [ 4 ]
    }
    //
    //
    //
    Text {
        id: content
        //
        //
        //
        height: contentHeight
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 8
        //
        //
        //
        wrapMode: Text.WordWrap
        //
        //
        //
        color: Colours.veryDarkSlate
        //
        //
        //
        font.family: fonts.light
        font.pixelSize: 12
    }
    //
    //
    //
    property alias media: content.text
}
