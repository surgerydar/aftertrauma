import QtQuick 2.6
import QtQuick.Controls 2.1

import "../colours.js" as Colours

Item {
    id: container
    //
    //
    //
    height: Math.max(64,content.height + 16)
    //implicitHeight: Math.max(64,content.paintedHeight + 16)
    //
    //
    //
    Background {
        anchors.fill: parent
        fill: Colours.almostWhite
        radius: [4]
    }
    //
    //
    //
    Image {
        id: content
        //
        //
        //
        height: Math.min(width * ( sourceSize.height / sourceSize.width ),sourceSize.height)
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 8
        //
        //
        //
        fillMode: Image.PreserveAspectFit
    }
    //
    //
    //
    property alias media: content.source
}
