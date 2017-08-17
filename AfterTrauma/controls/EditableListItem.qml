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
    leftPadding: 0
    //
    //
    //
    background: Rectangle {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width
        color: Colours.red
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
        SwipeDelegate.onClicked: listView.model.remove(index)
    }
}
