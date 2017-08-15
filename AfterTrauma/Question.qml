import QtQuick 2.6
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

Item {
    id: container
    //
    //
    //
    height: questionText.height + stars.height + 24// 86
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
        height: contentHeight
        anchors.top: parent.top
        anchors.left: parent.left
        //anchors.bottom: parent.verticalCenter
        anchors.right: parent.right
        anchors.margins: 8
        //
        //
        //
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        //fontSizeMode: Text.Fit
        wrapMode: Text.Wrap
        font.family: fonts.light
        font.pixelSize: 18
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
        height: 42
        anchors.left: parent.left
        anchors.right: parent.right
        //anchors.top: parent.verticalCenter
        anchors.bottom: parent.bottom
        anchors.margins: 8
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
        anchors.top: stars.top
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
    property int questionIndex: 0
}
