import QtQuick 2.6
import QtQuick.Controls 2.1

import "../colours.js" as Colours

Slider {
    id: control

    background: Rectangle {
        x: control.leftPadding
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 200
        implicitHeight: 4
        width: control.availableWidth
        height: implicitHeight
        radius: 2
        color: Colours.almostWhite
        /*
        Rectangle {
            width: control.visualPosition * parent.width
            height: parent.height
            color: "#21be2b"
            radius: 2
        }
        */
    }

    handle: Rectangle {
        x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 24
        implicitHeight: 48
        height: control.availableHeight
        width: height / 2
        radius: width / 2
        color: Colours.almostWhite
        Rectangle {
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: -6
            width: 2
            height: parent.width - 6
            color: Colours.red
        }
        Rectangle {
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: -2
            width: 2
            height: parent.width - 2
            color: Colours.red
        }
        Rectangle {
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: 2
            width: 2
            height: parent.width - 2
            color: Colours.red
        }
        Rectangle {
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: 6
            width: 2
            height: parent.width - 6
            color: Colours.red
        }
    }
    property bool showTicks: false
}
