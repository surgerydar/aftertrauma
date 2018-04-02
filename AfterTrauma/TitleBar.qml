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
        id: menuButton
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.margins: 8
        image: "icons/burger.png"
        onClicked: {
            mainMenu.open();
        }
    }
    //
    //
    //
    AfterTrauma.Button {
        id: home
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: menuButton.right
        anchors.leftMargin: 4
        image: "icons/title_logo.png"
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
        text: userProfile ? userProfile.username : "login or register"
        //
        //
        //
        onClicked: {
            if ( loggedIn ) {
                stack.push("qrc:///ProfileManager.qml", { profile: userProfile } );
            } else {
                register.open();
            }
        }
    }
}
