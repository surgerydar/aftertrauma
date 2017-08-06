import QtQuick 2.6
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

Item {
    id: container
    //
    //
    //
    height: 86
    //
    //
    //
    AfterTrauma.Background {
        id: background
        anchors.fill: parent
        fill: container.score > 0. ? Colours.darkGreen : Colours.blue
    }
    //
    //
    //
    Text {
        id: questionText
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.verticalCenter
        anchors.right: parent.right
        //
        //
        //
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        fontSizeMode: Text.Fit
        font.family: fonts.light
        font.pixelSize: 32
        color: Colours.almostWhite
    }
    //
    //
    //
    Row {
        id: stars
        //
        //
        //
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.verticalCenter
        anchors.bottom: parent.bottom
        anchors.margins: 4
        //
        //
        //
        Repeater {
            model: 10
            Image {
                anchors.verticalCenter: stars.verticalCenter
                height: stars.height
                width: stars.width / 10.
                fillMode: Image.PreserveAspectFit
                source: ( container.score * container.width ) >= ( ( index + 1 ) * width ) - ( width / 2 ) ? "icons/star_full.png" : "icons/star_empty.png"
            }
        }
    }
    //
    //
    //
    MouseArea {
        anchors.top: parent.verticalCenter
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        preventStealing: true
        //
        //
        //
        onPressed: {
            updateScore();
        }
        onReleased: {
            updateScore();
        }
        onPositionChanged: {
            updateScore();
        }
        function updateScore() {
            container.score = mouseX / width
        }
    }
    //
    //
    //

    //
    //
    //
    property alias question: questionText.text
    property real score: 0.
}
