import QtQuick 2.0
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

Item {
    height: 64
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    //
    //
    //
    Rectangle {
        anchors.fill: parent
        color: Colours.blue
        opacity: 0.5
    }
    //
    //
    //
    AfterTrauma.Button {
        id: home
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 4
        image: "icons/title_logo.png"
        backgroundColour: "transparent"
        //
        //
        //
        onClicked: {
            stack.pop(null);
        }
    }
    //
    //
    //
    AfterTrauma.Button {
        id: account
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 4
        textColour: Colours.blue
        backgroundColour: Colours.almostWhite
        direction: "Right"
        textHorizontalAlignment: Text.AlignRight
        textVerticalAlignment: Text.AlignTop
        textSize: 12
        image: "icons/profile_icon.png"
        text: "login or register"
        //
        //
        //
        onClicked: {
            register.show();
        }
    }
}
