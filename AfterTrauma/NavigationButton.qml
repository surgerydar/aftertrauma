import QtQuick 2.0
import QtQuick.Controls 2.1

import "colours.js" as Colours

Rectangle {
    id: container
    width: 48
    height: width
    radius: width / 2
    color: Colours.darkOrange
    //
    //
    //
    property alias icon: iconImage.source
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
        anchors.margins: 8
        fillMode: Image.PreserveAspectFit
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
