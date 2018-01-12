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
        font.pixelSize: 24
        color: Colours.almostWhite
    }
    AfterTrauma.Slider {
        id: slider
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
        updateDisplay(slider.value);
    }
    //
    //
    //
    function updateDisplay(value) {
        var start = startDate.getTime();
        var end = endDate.getTime();
        var current = ((end -start)*value)+start;
        currentDate.setTime(current);
        display.text = currentDate.toDateString();
        control.dateChanged();
    }
    function setDate(date) {
        if ( currentDate !== date ) {
            var start = startDate.getTime();
            var end = endDate.getTime();
            var current = date.getTime();
            if ( current < start ) {
                startDate = date;
                start = current;
            }
            if ( current > end ) {
                endDate = date;
                end = current;
            }
            var value = ( current - start ) / ( end - start );
            updateDisplay(value);
        }
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
