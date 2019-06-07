import QtQuick 2.6
import QtQuick.Controls 2.1

import "../colours.js" as Colours

Item {
    id: control
    height: 96
    Slider {
        id: slider
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        onValueChanged: {
            updateDisplay();
        }
    }
    Text {
        id: display
        height: 48
        anchors.top: slider.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 24
        color: Colours.almostWhite
    }
    //
    //
    //
    Component.onCompleted: {
        updateDisplay();
    }
    //
    //
    //
    function updateDisplay() {
        startDate.setHours(0,0,0);
        endDate.setHours(0,0,0);
        var start = startDate.getTime();
        var end = endDate.getTime();
        var current = ((end -start)*slider.value)+start;
        currentDate.setTime(current);
        display.text = currentDate.toDateString();
        control.dateChanged();
    }
    //
    //
    //
    signal dateChanged();
    //
    //
    //
    property var startDate: new Date(0)
    property var endDate: new Date()
    property var currentDate: new Date();
}
