import QtQuick 2.0

import "controls" as AfterTrauma
import "colours.js" as Colours

Item {
    id: container
    height: 64
    anchors.left: parent.left
    anchors.right: parent.right
    //
    //
    //
    states: [
        State {
            name: "closed"
            PropertyChanges {
                target: container
                y: parent.height
            }
        },
        State {
            name: "open"
            PropertyChanges {
                target: container
                y: parent.height - height
            }
        }
    ]
    transitions: Transition {
        NumberAnimation { properties: "y"; easing.type: Easing.InOutQuad }
    }
    //
    //
    //
    Rectangle {
        id: background
        anchors.fill: parent
        color: Colours.darkOrange
    }
    //
    //
    //
    Row {
        anchors.fill: parent
        NavigationButton {
            width: parent.width / 5
            height: parent.height - 16
            anchors.verticalCenter: parent.verticalCenter
            label: "recovery"
            icon: "icons/recovery.png"
            onClicked:{
                stack.navigateTo("qrc:///Questionnaire.qml");
                mainMenu.close();
            }
        }
        NavigationButton {
            width: parent.width / 5
            height: parent.height - 16
            anchors.verticalCenter: parent.verticalCenter
            label: "diary"
            icon: "icons/diary.png"
            onClicked:{
                stack.navigateTo("qrc:///Diary.qml");
                mainMenu.close();
            }
        }
        NavigationButton {
            width: parent.width / 5
            height: parent.height - 16
            anchors.verticalCenter: parent.verticalCenter
            label: "chat"
            icon: "icons/chat.png"
            enabled: userProfile && !userProfile.blocked && loggedIn && chatChannel.connected
            badge: ( userProfile && userProfile.blocked ) ? "blocked" : unreadChatsModel.totalUnread > 0 ? unreadChatsModel.totalUnread : ""
            onClicked:{
                stack.navigateTo("qrc:///GroupChatManager.qml");
                mainMenu.close();
            }
        }
        NavigationButton {
            width: parent.width / 5
            height: parent.height - 16
            anchors.verticalCenter: parent.verticalCenter
            label: "information"
            icon: "icons/resources.png"
            onClicked:{
                stack.navigateTo("qrc:///FactsheetCategories.qml");
                mainMenu.close();
            }
        }
        NavigationButton {
            width: parent.width / 5
            height: parent.height - 16
            anchors.verticalCenter: parent.verticalCenter
            label: "menu"
            icon:mainMenu.state === "open" ? "icons/right_arrow.png" : "icons/burger_menu.png"
            onClicked: {
                if ( mainMenu.state === "open" ) {
                    mainMenu.close();
                } else {
                    mainMenu.open();
                }
            }
        }
    }
}
