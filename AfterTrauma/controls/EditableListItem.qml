import QtQuick 2.6
import QtQuick.Controls 2.1

import "../colours.js" as Colours

SwipeDelegate {
    id: container
    //
    //
    //
    height: 64
    //
    //
    //
    leftPadding: 4
    rightPadding: 4
    //
    //
    //
    background: Item {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width
        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.right: parent.horizontalCenter
            color: Colours.darkGreen
        }
        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            color: Colours.red
        }
    }
    //
    //
    //
    swipe.left: Label {
        id: editLabel
        text: "Edit"
        color: Colours.almostWhite
        verticalAlignment: Label.AlignVCenter
        padding: 12
        height: parent.height
        anchors.left: parent.left
        background: Rectangle {
            color: Colours.darkGreen
        }
        SwipeDelegate.onClicked: {
            swipe.close();
            container.edit();
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                container.edit();
            }
        }
    }
    //
    //
    //
    swipe.right: Label {
        id: deleteLabel
        text: "Delete"
        color: Colours.almostWhite
        verticalAlignment: Label.AlignVCenter
        padding: 12
        height: parent.height
        anchors.right: parent.right
        background: Rectangle {
            color: Colours.red
        }
        SwipeDelegate.onClicked: {
            swipe.close();
            container.remove();
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                swipe.close();
                container.remove();
            }
        }
    }
    //
    //
    //
    signal edit()
    signal remove()
}
