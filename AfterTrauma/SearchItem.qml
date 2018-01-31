import QtQuick 2.6
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

Item {
    id: container
    //
    //
    //
    height: 64
    //
    //
    //
    AfterTrauma.Background {
        anchors.fill: parent
        fill: Colours.darkOrange
    }
    //
    //
    //
    Text {
        id: titleText
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 8
        //
        //
        //
        font.weight: Font.Light
        font.family: fonts.light
        font.pixelSize: 18
        color: Colours.almostWhite
        //
        //
        //
        horizontalAlignment: Text.AlignLeft
    }
    Text {
        id: summaryText
        anchors.top: titleText.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 8
        //
        //
        //
        font.weight: Font.Light
        font.family: fonts.light
        font.pixelSize: 12
        wrapMode: Text.WordWrap
        elide: Text.ElideRight
        color: Colours.almostWhite
        //
        //
        //
        horizontalAlignment: Text.AlignLeft
    }
    //
    //
    //
    MouseArea {
        anchors.fill: parent
        onClicked: {
            parent.clicked();
        }
    }
    //
    //
    //
    signal clicked();
    //
    //
    //
    property alias title: titleText.text
    property alias summary: summaryText.text
}
