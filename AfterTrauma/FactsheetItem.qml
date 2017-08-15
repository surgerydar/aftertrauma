import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

Item {
    id: container
    //
    //
    //
    height: Math.max(64,textView.contentHeight+16)
    //
    //
    //
    AfterTrauma.Background {
        id: background
        anchors.fill: parent
        radius: [0]
    }
    //
    //
    //
    Text {
        id: textView
        anchors.fill: parent
        anchors.margins: 8
        wrapMode: Text.Wrap
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 48
        color: Colours.almostWhite
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
    //
    //
    //
    signal clicked();
    //
    //
    //
    property alias radius: background.radius
    property alias backgroundColour: background.fill
    property alias text: textView.text
    property alias textSize: textView.font.pixelSize

}
