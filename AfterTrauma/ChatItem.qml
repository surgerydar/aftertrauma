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
        fill: Colours.darkPurple
    }
    //
    //
    //
    Image {
        id: avatarImage
        width: height
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 8
        //
        //
        //
        fillMode: Image.PreserveAspectFit
        //
        //
        //
        source: "icons/profile_icon.png"
    }
    //
    //
    //
    Text {
        id: toText
        anchors.top: parent.top
        anchors.left: avatarImage.right
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 8
        //
        //
        //
        font.weight: Font.Light
        font.family: fonts.light
        font.pixelSize: 18
        fontSizeMode: Text.Fit
        color: Colours.almostWhite
        //
        //
        //
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }
    //
    //
    //
    property alias avatar: avatarImage.source
    property alias to: toText.text
}
