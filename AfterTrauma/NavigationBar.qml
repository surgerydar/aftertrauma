import QtQuick 2.0

import "colours.js" as Colours

Item {
    height: 64
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    //
    //
    //
    Rectangle {
        id: background
        anchors.fill: parent
        anchors.topMargin: 36
        color: Colours.darkOrange
    }
    //
    //
    //
    NavigationButton {
        id: helpButton
        anchors.bottom: parent.bottom
        anchors.right: chatButton.left
        anchors.margins: 4
        icon: "icons/help.png"
        onClicked: {
            stack.push("qrc:///Help.qml");
        }
    }
    NavigationButton {
        id: chatButton
        anchors.bottom: parent.bottom
        anchors.right: addButton.left
        anchors.margins: 4
        icon: "icons/chat.png"
        onClicked: {
            stack.push("qrc:///Chat.qml");
        }
    }
    NavigationButton {
        id: addButton
        width: 64
        anchors.bottom: parent.bottom
        anchors.right: parent.horizontalCenter
        anchors.rightMargin: -4
        icon: "icons/add.png"
        onClicked: {
            var options = [
                        { title: "Questionnaire", destination: "Questionnaire.qml" },
                        { title: "Challenge", destination: "ChallengeManager.qml" },
                        { title: "Image", destination: "ImageManager.qml", options: { date: 0 } },
                        { title: "Notes", destination: "NotesManager.qml", options: { date: 0 } }
                    ];
            shortcut.setOptions( options );
            shortcut.open();
        }
    }
    NavigationButton {
        id: chartButton
        width: 64
        anchors.bottom: parent.bottom
        anchors.left: parent.horizontalCenter
        anchors.leftMargin: -4
        icon: "icons/chart.png"
        onClicked: {
            var options = [
                        //{ title: "Timeline", destination: "Timeline.qml" },
                        { title: "Timeline", destination: "TestTimeline.qml" },
                        { title: "Weekly", destination: "Progress.qml", options: { period: "week" } },
                        { title: "Monthly", destination: "Progress.qml", options: { period: "month" } },
                        { title: "Yearly", destination: "Progress.qml", options: { period: "year" } }
                    ];
            shortcut.setOptions( options );
            shortcut.open();
        }
    }

    NavigationButton {
        id: factsheetButton
        anchors.bottom: parent.bottom
        anchors.left: chartButton.right
        anchors.margins: 4
        icon: "icons/factsheet.png"
        onClicked: {
            stack.push("qrc:///FactsheetCategories.qml");
        }
    }
    NavigationButton {
        id: searchButton
        anchors.bottom: parent.bottom
        anchors.left: factsheetButton.right
        anchors.margins: 4
        icon: "icons/search.png"
        onClicked: {
            stack.push("qrc:///Search.qml");
        }
    }
}
