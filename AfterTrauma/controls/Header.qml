import QtQuick 2.6
//import QtQuick.Controls 2.1

import "../colours.js" as Colours

Item {
    id: container
    //
    //
    //
    height: ( titleText.visible ? titleText.height + 4 : 0 ) + ( subTitleText.visible ? subTitleText.height + 4 : 0 )
    anchors.left: parent.left
    anchors.right: parent.right
    //
    //
    //
    Background {
        height: 64
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
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
        height: 64
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: ( showNavigation ? backButton.width + 4: 0 )
        anchors.right: parent.right
        anchors.rightMargin: ( showNavigation ? backButton.width + 4 : 0 )
        //
        //
        //
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        fontSizeMode: Text.Fit
        color: container.textColour
        font.pointSize: 36
        font.weight: Font.Light
        font.family: fonts.light
        visible: title.length > 0
    }
    //
    // optional navigation
    //
    Button {
        id: backButton
        anchors.verticalCenter: titleText.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 4
        image: Qt.colorEqual(container.backgroundColour,Colours.almostWhite) ? "../icons/left_arrow_black.png" : "../icons/left_arrow.png"
        backgroundColour: "transparent"
        /*
        image: "../icons/left_arrow.png"
        backgroundColour: Qt.colorEqual(container.backgroundColour,Colours.almostWhite) ? Colours.veryLightSlate : "transparent"
        */
        radius: 0
        visible: showNavigation && stack && stack.depth > 1
        onClicked: {
            if ( stack ) {
                if ( validate ) {
                    if ( validate() ) stack.pop();
                } else{
                    stack.pop();
                }
            }
        }
    }
    //
    //
    //
    Background {
        anchors.top: subTitleText.top
        anchors.left: parent.left
        anchors.bottom: subTitleText.bottom
        anchors.right: parent.right
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
        anchors.leftMargin: 4
        anchors.right: parent.right
        anchors.rightMargin: 4
        anchors.topMargin: 4
        //
        //
        //
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        fontSizeMode: Text.Fit
        color: container.textColour
        font.pointSize: 36
        font.weight: Font.Light
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
    property bool showNavigation: true
    property var validate: null
}
