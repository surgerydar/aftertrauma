import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.0
import SodaControls 1.0

import "controls" as AfterTrauma
import "colours.js" as Colours

Rectangle {
    id: container
    width: parent.width
    x: parent.width
    anchors.top: parent.top
    anchors.bottom: navigationBar.top
    anchors.bottomMargin: 4
    color: "transparent"//Qt.rgba(0,0,0,.5)
    //
    //
    //
    state: "closed"
    states: [
        State {
            name: "closed"
            PropertyChanges {
                target: container
                x: parent.width
            }
        },
        State {
            name: "open"
            PropertyChanges {
                target: container
                x: parent.width-container.width
            }
        }
    ]
    transitions: Transition {
        NumberAnimation { properties: "x"; easing.type: Easing.InOutQuad }
    }
    //
    //
    //
    function open() {
        container.state = "open";
    }
    function close() {
        container.state = "closed";
    }
    //
    //
    //
    MouseArea {
        anchors.fill: parent
        onClicked: {
            close();
        }
    }
    //
    //
    //
    Rectangle {
        width: menuItems.width + 32
        height: Math.min( parent.height, (menuItemsModel.count * ( 48 + menuItems.spacing ) ) + 16 )
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        color: Colours.darkOrange
        //
        //
        //
        ListView {
            id: menuItems
            width: contentItem.childrenRect.width
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: 8
            spacing: 16
            model: menuItemsModel
            ScrollBar.vertical: ScrollBar { }
        }
    }
    //
    // TODO: perhaps externalise this to JSON
    //
    VisualItemModel {
        id: menuItemsModel
        AfterTrauma.Button {
            //anchors.left: parent.left
            textHorizontalAlignment: Text.AlignLeft
            textVerticalAlignment: Text.AlignVCenter
            textSize: 32
            text: "My Challenges"
            image: "icons/challenge.png"
            direction: "Left"
            spacing: 8
            onClicked: {
                stack.navigateTo("qrc:///ChallengeManager.qml");
                container.close();
            }
        }
        AfterTrauma.Button {
            //anchors.left: parent.left
            textHorizontalAlignment: Text.AlignLeft
            textVerticalAlignment: Text.AlignVCenter
            textSize: 32
            text: "My Progress"
            image: "icons/graphs.png"
            direction: "Left"
            spacing: 8
            onClicked: {
                stack.navigateTo("qrc:///Progress.qml",{ period: "week" });
                container.close();
            }
        }
        AfterTrauma.Button {
            //anchors.left: parent.left
            textHorizontalAlignment: Text.AlignLeft
            textVerticalAlignment: Text.AlignVCenter
            textSize: 32
            text: "My Prescriptions"
            image: "icons/factsheet.png"
            direction: "Left"
            spacing: 8
            onClicked: {
                onClicked: {
                    if ( loggedIn ) {
                        stack.push("qrc:///PrescriptionManager.qml" );
                    } else {
                        register.open();
                    }
                }
                container.close();
            }
        }
        AfterTrauma.Button {
            //anchors.left: parent.left
            textHorizontalAlignment: Text.AlignLeft
            textVerticalAlignment: Text.AlignVCenter
            textSize: 32
            text: userProfile && loggedIn ? userProfile.username || "About Me" : "login or register"
            image: "icons/about_me.png"
            direction: "Left"
            spacing: 8
            onClicked: {
                onClicked: {
                    if ( loggedIn ) {
                        stack.push("qrc:///ProfileManager.qml", { profile: userProfile } );
                    } else {
                        register.open();
                    }
                }
                container.close();
            }
        }
        AfterTrauma.Button {
            //anchors.left: parent.left
            textHorizontalAlignment: Text.AlignLeft
            textVerticalAlignment: Text.AlignVCenter
            textSize: 32
            text: "Search"
            image: "icons/search.png"
            direction: "Left"
            spacing: 8
            onClicked: {
                stack.navigateTo("qrc:///Search.qml");
                container.close();
            }
        }
        AfterTrauma.Button {
            //anchors.left: parent.left
            textHorizontalAlignment: Text.AlignLeft
            textVerticalAlignment: Text.AlignVCenter
            textSize: 32
            text: "About"
            image: "icons/help.png"
            direction: "Left"
            spacing: 8
            onClicked: {
                stack.navigateTo("qrc:///Help.qml");
                container.close();
            }
        }
    }
}
