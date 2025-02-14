import QtQuick 2.6
import QtQuick.Controls 2.1

import SodaControls 1.0

import "controls" as AfterTrauma
import "colours.js" as Colours
import "utils.js" as Utils

Item {
    id: container
    //
    //
    //
    //height: 86 //Math.max( 108, Math.min(5,values?values.length:0) * 8 * 2 )
    height: width / 5.
    //
    //
    //
    AfterTrauma.Background {
        id: background
        anchors.fill: parent
        fill: Colours.slate
    }
    //
    //
    //
    Label {
        id: dateText
        width: height
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 4
        //
        //
        //
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        fontSizeMode: Text.Fit
        font.weight: Font.Light
        font.family: fonts.light
        font.pointSize: 32
        color: Colours.almostWhite
        text: container.date?Utils.shortDateVertical(container.date,true):"no date"
    }
    //
    //
    //
    MouseArea {
        anchors.fill: parent
        onClicked: {
            var d = new Date( date );
            stack.push( "qrc:///DiaryEntry.qml", { date: d } );
        }
    }
    //
    // Indicators
    //
    Image {
        id: imageIndicator
        width: height
        anchors.top: parent.top
        anchors.left: dateText.right
        anchors.bottom: parent.bottom
        anchors.margins: 4
        sourceSize.height: height
        sourceSize.width: width
        fillMode: Image.PreserveAspectCrop
        visible: status === Image.Ready
        source: firstBlockContent("image")
    }
    //
    //
    //
    Label {
        id: notesIndicator
        width: height
        anchors.top: parent.top
        anchors.left: imageIndicator.right
        anchors.bottom: parent.bottom
        anchors.margins: 4
        fontSizeMode: Label.Fit
        minimumPointSize: 12
        font.weight: Font.Light
        font.family: fonts.light
        font.pointSize: 32
        elide: Label.ElideRight
        wrapMode: Label.WordWrap
        topPadding: height / 3.
        bottomPadding: height / 3.
        leftPadding: 4
        rightPadding: 4
        color: Colours.darkSlate
        visible: text.length > 0
        text: firstBlockContent("text")

        background: Canvas { // 'document' icon background
            anchors.fill: parent
            onPaint: {
                var foldOffset = width / 8.;
                var ctx = getContext("2d");
                ctx.resetTransform();
                ctx.fillStyle = Colours.lightSlate;
                ctx.strokeStyle = Colours.almostWhite;
                ctx.lineWidth = 2;

                ctx.beginPath();
                ctx.rect(0,0,width,height);
                ctx.moveTo( 0., foldOffset );
                ctx.lineTo( foldOffset, 0. );
                ctx.fill();
                ctx.stroke();
            }
        }
    }
    //
    //
    //
    Image {
        id: challengeIndicator
        anchors.top: parent.top
        anchors.left: notesIndicator.right
        anchors.bottom: parent.bottom
        anchors.margins: 4
        fillMode: Image.PreserveAspectFit
        source: "icons/challenge.png"
    }
    //
    //
    //
    FlowerChart {
        id: flowerChart
        width: height
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 4
        enabled: false
        values: container.values //dailyModel.valuesForDate(date)
        animated: false
    }
    //
    //
    //
    function firstBlockContent(type) {
        //console.log( 'firstBlockContent : ' + type );
        //var blocks = dailyModel.blocksForDate(date);
        for ( var i = 0; i < container.blocks.length; i++ ) {
            if ( blocks[ i ].type === type ) {
                if ( type === "image" ) {
                    var path = SystemUtils.documentDirectory() + '/' + blocks[ i ].content;
                    if ( !SystemUtils.fileExists(path) ) {
                        path = SystemUtils.mediaPath(blocks[ i ].content);
                    }
                    return 'file://' + path;
                } else {
                    return blocks[ i ].content;
                }
            }
        }
        return "";
    }

    //
    //
    //
    property var date: 0
    property var values: []
    property var blocks: []
    property alias hasChallenges: challengeIndicator.visibles
}
