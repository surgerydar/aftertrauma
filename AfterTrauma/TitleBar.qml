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
    Image {
        id: menuButton
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 4
        source: "icons/burger.png"
        MouseArea {
            anchors.fill: parent
            onClicked: {
                mainMenu.open();
            }
        }
    }
    //
    //
    //
    Image {
        id: home
        anchors.left: menuButton.right
        anchors.leftMargin: 4
        /*
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 4
        anchors.right: parent.horizontalCenter
        anchors.rightMargin: 2
        */
        anchors.top: menuButton.top
        anchors.bottom: menuButton.bottom
        fillMode: Image.PreserveAspectFit
        source: "icons/title_logo.png"
        MouseArea {
            anchors.fill: parent
            onClicked: {
                stack.pop(null);
            }
        }
    }
    //
    //
    //
    Image {
        id: account
        /*
        anchors.top: parent.top
        anchors.topMargin: 8
        */
        height: 32
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 4
        anchors.right: parent.right
        anchors.rightMargin: 8
        fillMode: Image.PreserveAspectFit
        source: "icons/profile_icon.png"
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if ( loggedIn ) {
                    stack.push("qrc:///ProfileManager.qml", { profile: userProfile } );
                } else {
                    register.open();
                }
            }
        }
    }
    Label {
        anchors.top: parent.top
        anchors.topMargin: 8
        anchors.left: parent.horizontalCenter
        anchors.leftMargin: 2
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        anchors.right: account.horizontalCenter
        anchors.rightMargin: -8
        verticalAlignment: Label.AlignTop
        horizontalAlignment: Label.AlignRight
        elide: Label.ElideRight
        font.family: fonts.light
        font.pointSize: 14
        color: Colours.almostWhite
        text: userProfile ? userProfile.username : "login or register"
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if ( loggedIn ) {
                    stack.push("qrc:///ProfileManager.qml", { profile: userProfile } );
                } else {
                    register.open();
                }
            }
        }
    }
}
