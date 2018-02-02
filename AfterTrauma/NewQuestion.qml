import QtQuick 2.6
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

Item {
    id: container
    //
    //
    //
    height: questionText.height + ticks.height + 24
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
        font.weight: Font.Light
        font.family: fonts.light
        font.pixelSize: 18
        color: Colours.almostWhite
    }
    //
    //
    //
    Row {
        id: ticks
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
            model: 5
            Image {
                anchors.verticalCenter: ticks.verticalCenter
                height: ticks.height
                width: ticks.width / 5.
                fillMode: Image.PreserveAspectFit
                source: "icons/face" + index + ".png"
            }
        }
    }
    //
    //
    //
    Rectangle {
        id: indicator
        width: ticks.height
        x: indicatorPosition( container.score )
        height: 4
        anchors.bottom: parent.bottom
        color: Colours.red
        visible: container.score > 0

        Behavior on x {
            PropertyAnimation {}
        }
    }
    //
    //
    //
    MouseArea {
        anchors.top: ticks.top
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
        //
        //
        //
        function updateScore() {
            //
            //
            //
            container.score = mouseX / width
        }
    }
    //
    //
    //
    function indicatorPosition( score ) {
        var offset = score * container.width;
        var starWidth = ticks.width / 5.;
        var index = Math.max( 0, Math.min( 4., Math.floor( offset / starWidth ) ) );
        var indicatorPosn = ( index * starWidth ) + ( starWidth / 2. );
        //indicator.x = ticks.x + ( indicatorPosn - ( indicator.width / 2. ) );
        return ticks.x + ( indicatorPosn - ( indicator.width / 2. ) );
    }
    //
    //
    //
    property alias question: questionText.text
    property real score: 0.
    property int questionIndex: 0
}
