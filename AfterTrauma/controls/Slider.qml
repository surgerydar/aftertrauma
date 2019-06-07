import QtQuick 2.6
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0
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

    handle: Item {
        id: handleContainer
        x: control.leftPadding + control.visualPosition * (control.availableWidth - handle.width)
        y: control.topPadding + control.availableHeight / 2 - handle.height / 2
        implicitWidth: 48
        implicitHeight: 48
        height: control.availableHeight
        width: height
        Rectangle {
            id: handle
            width: handleContainer.width / 2
            height: handleContainer.height / 2
            anchors.centerIn: parent
            radius: width / 2
            color: Colours.almostWhite
            border.color: Colours.veryDarkSlate
            border.width: 4
            visible: false
        }
        DropShadow {
            id: shadow
            anchors.fill: parent
            //horizontalOffset: 3
            //verticalOffset: 3
            radius: handle.radius
            samples: 17
            color: Colours.veryDarkSlate
            source: handle
        }
    }
    property bool showTicks: false
}
