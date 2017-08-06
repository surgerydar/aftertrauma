import QtQuick 2.6
import QtQuick.Controls 2.1

import "../colours.js" as Colours

Item {
    id: container
    //
    //
    //
    height: ( titleText.visible ? titleText.height + 8 : 0 ) + ( subTitleText.visible ? subTitleText.height + 8 : 0 )
    anchors.left: parent.left
    anchors.right: parent.right
    //
    //
    //
    Background {
        anchors.top: titleText.top
        anchors.left: titleText.left
        anchors.bottom: titleText.bottom
        anchors.right: titleText.right
        fill: container.backgroundColour
        visible: title.length > 0
    }
    //
    //
    //
    Text {
        id: titleText
        //
        //
        //
        height: 48
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        //
        //
        //
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        fontSizeMode: Text.Fit
        color: container.textColour
        font.pixelSize: 36
        font.family: fonts.light
        visible: title.length > 0
    }
    //
    //
    //
    Background {
        anchors.top: subTitleText.top
        anchors.left: subTitleText.left
        anchors.bottom: subTitleText.bottom
        anchors.right: subTitleText.right
        fill: container.backgroundColour
        visible: subtitle.length > 0
    }
    Text {
        id: subTitleText
        //
        //
        //
        height: 48
        anchors.top: titleText.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 8
        //
        //
        //
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        fontSizeMode: Text.Fit
        color: container.textColour
        font.pixelSize: 36
        font.family: fonts.light
        visible: subtitle.length > 0
    }
    //
    //
    //
    property alias title: titleText.text
    property alias subtitle: subTitleText.text
    property color backgroundColour: Colours.darkOrange
    property color textColour: Colours.almostWhite
}
