import QtQuick 2.6
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

Item {
    id: control
    height: 96
    //
    //
    //
    Text {
        id: display
        height: 32
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.family: fonts.bold
        font.pointSize: 24
        color: Colours.almostWhite
    }
    //
    //
    //
    AfterTrauma.Slider {
        id: slider
        value: 1
        anchors.top: display.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        onValueChanged: {
            updateDisplay(value);
        }
        onPositionChanged: {
            updateDisplay(position);
        }
    }
    //
    //
    //
    Component.onCompleted: {
        updateDisplay(value);
    }
    //
    //
    //
    function updateDisplay(value) {
        /*
        var range = dailyModel.getDateRange();
        var current = Math.round((range.max-range.min)*value+range.min);
        */
        var min = globalMinimumDate.getTime();
        var max = globalMaximumDate.getTime();
        var current = Math.round((max-min)*value+min);
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
    property var currentDate: new Date()
    property alias value: slider.value
    property alias showSlider: slider.visible
}
