import QtQuick 2.6
import QtQuick.Controls 2.1

import "../colours.js" as Colours

CheckBox {
    id: control
    height: 48
    implicitWidth: control.height + ( control.text.length > 0 ? label.implicitWidth : 0 )
    baselineOffset: 0 //label.baselineOffset
    //
    //
    //
    indicator: Rectangle {
        id: indicatorBox
        width: control.height - 8
        anchors.top: control.top
        anchors.bottom: control.bottom
        anchors.left: parent.direction === "Left" ? parent.left : undefined
        anchors.right: parent.direction === "Right" ? parent.right : undefined
        anchors.margins: 4
        radius: 4
        color: Colours.veryLightSlate
        Image {
            anchors.fill: parent
            anchors.margins: 4
            visible: control.checked
            fillMode: Image.PreserveAspectFit
            source: "../icons/tick.png"
        }
    }
    //
    //
    //
    contentItem: Text {
        id: label
        anchors.top: control.top
        anchors.bottom: control.bottom
        anchors.left: control.direction === "Left" ? control.indicator.right : control.left
        anchors.right: control.direction === "Right" ? control.indicator.left : control.right
        anchors.leftMargin: control.direction === "Left" ? 4 : 0
        anchors.rightMargin: control.direction === "Right" ? 4 : 0
        color: Colours.veryDarkSlate
        font.pointSize: 18
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: control.direction === "Left" ? Text.AlignLeft : Text.AlignRight
        text: control.text
    }
    //
    //
    //
    property alias indicatorColour: indicatorBox.color
    property alias textColour: label.color
    property alias textSize: label.font.pointSize
    property string direction: "Left"
}
