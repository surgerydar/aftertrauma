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
        id: home
        height: 32
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 4
        fillMode: Image.PreserveAspectFit
        source: "icons/title_logo.png"
        MouseArea {
            anchors.fill: parent
            onClicked: {
                stack.pop(null);
            }
            onPressAndHold: {
                utilityWindow.open();
            }
        }
    }
}
