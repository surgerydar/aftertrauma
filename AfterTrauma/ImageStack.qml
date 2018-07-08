import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

Item {
    id: container
    //
    //
    //
    Image {
        id: nextImage
        anchors.fill: parent
        anchors.rightMargin: 4
        anchors.bottomMargin: 4
        fillMode: Image.PreserveAspectCrop
        source: images.length > 1 ? images[1] : ""
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.color: Colours.almostWhite
            border.width: 2
        }
    }
    Image {
        id: currentImage
        anchors.fill: parent
        anchors.leftMargin: 4
        anchors.topMargin: 4
        fillMode: Image.PreserveAspectCrop
        source: images.length > 0 ? images[0] : ""
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.color: Colours.almostWhite
            border.width: 2
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            images.push(images.shift());
            nextImage.source = images.length > 1 ? images[1] : ""
            currentImage.source = images.length > 0 ? images[0] : ""
        }
    }
    //
    //
    //
    property var images: []
}
