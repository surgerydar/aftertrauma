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
    }
    //
    //
    //
    Text {
        id: usernameText
        anchors.top: parent.top
        anchors.left: avatarImage.right
        anchors.right: parent.right
        anchors.margins: 8
        //
        //
        //
        font.weight: Font.Light
        font.family: fonts.light
        font.pixelSize: 32
        color: Colours.almostWhite
    }
    //
    //
    //
    Text {
        id: profileText
        anchors.top: usernameText.bottom
        anchors.left: avatarImage.right
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        //
        //
        //
        wrapMode: Text.WordWrap
        elide: Text.ElideRight
        font.weight: Font.Light
        font.family: fonts.light
        font.pixelSize: 24
        color: Colours.almostWhite
    }


    property alias avatar: avatarImage.source
    property alias username: usernameText.text
    property alias profile: profileText.text
}
