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
        fill: container.score > 0. ? Colours.blue : Colours.darkBlue
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
        anchors.bottomMargin: 8
        anchors.leftMargin: 32
        anchors.rightMargin: 32
        //
        //
        //
        Repeater {
            model: 4
            Image {
                anchors.verticalCenter: ticks.verticalCenter
                height: ticks.height
                width: ticks.width / 4.
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
        anchors.fill: ticks
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
            var xStep = ticks.childrenRect.width / 4;
            var scoreStep = 1. / 4;
            for ( var i = 3; i >= 0; i-- ) {
                if ( i * xStep <= mouseX ) {
                    container.score = ( i + 1 ) * scoreStep;
                    break;
                }
            }
        }
    }
    //
    //
    //
    function indicatorPosition( score ) {
        var index = Math.floor( ( 4 - 1 ) * score );
        var offset = ticks.children[ index ].x + ( ticks.children[ index ].width - indicator.width ) / 2.;
        //console.log( 'ticks.children.length=' + ticks.children.length + 'score=' + score + ' index=' + index + ' offset=' + offset );
        return ticks.x + offset;
    }
    //
    //
    //
    property alias question: questionText.text
    property real score: 0.
    property int questionIndex: 0
}
