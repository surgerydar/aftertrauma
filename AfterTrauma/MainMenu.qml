import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.0
import SodaControls 1.0

import "controls" as AfterTrauma
import "colours.js" as Colours

Rectangle {
    id: container
    width: parent.width
    x: -width
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    color: Qt.rgba(0,0,0,.5)
    //
    //
    //
    state: "closed"
    states: [
        State {
            name: "closed"
            PropertyChanges {
                target: container
                x: -container.width
            }
        },
        State {
            name: "open"
            PropertyChanges {
                target: container
                x: 0
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
        width: parent.width <= 320 ? parent.width : parent.width * .75
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        color: Colours.darkOrange
        //
        //
        //
        AfterTrauma.Button {
            id: closeButton
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 8
            image: "icons/left_arrow.png"
            onClicked: {
                close();
            }
        }
        //
        //
        //
        ListView {
            id: menuItems
            anchors.top: closeButton.bottom
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 8
            spacing: 4
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
            anchors.left: parent.left
            textHorizontalAlignment: Text.AlignLeft
            textVerticalAlignment: Text.AlignVCenter
            textSize: 32
            text: "ADD"
        }
        AfterTrauma.Button {
            anchors.right: parent.right
            textHorizontalAlignment: Text.AlignRight
            textVerticalAlignment: Text.AlignVCenter
            textSize: 32
            text: "My Recovery"
            image: "icons/add.png"
            direction: "Right"
            spacing: 8
            onClicked: {
                stack.navigateTo("qrc:///Questionnaire.qml");
                container.close();
            }
        }
        AfterTrauma.Button {
            anchors.right: parent.right
            textHorizontalAlignment: Text.AlignRight
            textVerticalAlignment: Text.AlignVCenter
            textSize: 32
            text: "Challenge"
            image: "icons/add.png"
            direction: "Right"
            spacing: 8
            onClicked: {
                stack.navigateTo("qrc:///ChallengeManager.qml");
                container.close();
            }
        }
        /*
        AfterTrauma.Button {
            anchors.right: parent.right
            textHorizontalAlignment: Text.AlignRight
            textVerticalAlignment: Text.AlignVCenter
            textSize: 32
            text: "Image"
            image: "icons/add.png"
            direction: "Right"
            spacing: 8
            onClicked: {
                stack.navigateTo("qrc:///ImageManager.qml");
                container.close();
            }
        }
        AfterTrauma.Button {
            anchors.right: parent.right
            textHorizontalAlignment: Text.AlignRight
            textVerticalAlignment: Text.AlignVCenter
            textSize: 32
            text: "Notes"
            image: "icons/add.png"
            direction: "Right"
            spacing: 8
            onClicked: {
                stack.navigateTo("qrc:///NotesManager.qml");
                container.close();
            }
        }
        */
        AfterTrauma.Button {
            anchors.left: parent.left
            textHorizontalAlignment: Text.AlignLeft
            textVerticalAlignment: Text.AlignVCenter
            textSize: 32
            text: "PROGRESS"
        }
        AfterTrauma.Button {
            anchors.right: parent.right
            textHorizontalAlignment: Text.AlignRight
            textVerticalAlignment: Text.AlignVCenter
            textSize: 32
            text: "Diary"
            image: "icons/timeline.png"
            direction: "Right"
            spacing: 8
            onClicked: {
                stack.navigateTo("qrc:///Diary.qml");
                container.close();
            }
        }
        AfterTrauma.Button {
            anchors.right: parent.right
            textHorizontalAlignment: Text.AlignRight
            textVerticalAlignment: Text.AlignVCenter
            textSize: 32
            text: "My Progress"
            image: "icons/chart.png"
            direction: "Right"
            spacing: 8
            onClicked: {
                stack.navigateTo("qrc:///Progress.qml",{ period: "week" });
                container.close();
            }
        }
        AfterTrauma.Button {
            anchors.right: parent.right
            textHorizontalAlignment: Text.AlignRight
            textVerticalAlignment: Text.AlignVCenter
            textSize: 32
            text: "Information"
            image: "icons/resources.png"
            direction: "Right"
            spacing: 8
            onClicked: {
                stack.navigateTo("qrc:///FactsheetCategories.qml");
                container.close();
            }
        }
        AfterTrauma.Button {
            anchors.right: parent.right
            textHorizontalAlignment: Text.AlignRight
            textVerticalAlignment: Text.AlignVCenter
            textSize: 32
            text: "Search"
            image: "icons/search.png"
            direction: "Right"
            spacing: 8
            onClicked: {
                stack.navigateTo("qrc:///Search.qml");
                container.close();
            }
        }
        AfterTrauma.Button {
            anchors.right: parent.right
            textHorizontalAlignment: Text.AlignRight
            textVerticalAlignment: Text.AlignVCenter
            textSize: 32
            text: "Chat"
            image: "icons/chat.png"
            direction: "Right"
            spacing: 8
            enabled: userProfile
            onClicked: {
                stack.navigateTo("qrc:///ChatManager.qml");
                container.close();
            }
        }
        AfterTrauma.Button {
            anchors.right: parent.right
            textHorizontalAlignment: Text.AlignRight
            textVerticalAlignment: Text.AlignVCenter
            textSize: 32
            text: "About"
            image: "icons/help.png"
            direction: "Right"
            spacing: 8
            onClicked: {
                stack.navigateTo("qrc:///Help.qml");
                container.close();
            }
        }
    }
}
