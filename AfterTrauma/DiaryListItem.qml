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
    height: width / 4.
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
        text: container.date?Utils.shortDateVertical(container.date,true):""
    }
    //
    // Indicators
    //
    /*
    AfterTrauma.Button {
        id: imageIndicator
        width: height
        anchors.top: parent.top
        anchors.left: dateText.right
        anchors.bottom: parent.bottom
        anchors.margins: 4
        visible: (images&&images.length > 0)
        image: "icons/image.png"
        backgroundColour: "transparent"
        onClicked: {
            stack.push( "qrc:///ImageManager.qml", { date: date } );
        }
    }

    AfterTrauma.Button {
        id: notesIndicator
        width: height
        anchors.top: parent.top
        anchors.left: imageIndicator.right
        anchors.bottom: parent.bottom
        anchors.margins: 4
        visible: (notes&&notes.length > 0)
        image: "icons/notes.png"
        backgroundColour: "transparent"
        onClicked: {
            stack.push( "qrc:///NotesManager.qml", { date: date } );
        }
    }
    */
    Image {
        id: imageIndicator
        width: height
        anchors.top: parent.top
        anchors.left: dateText.right
        anchors.bottom: parent.bottom
        anchors.margins: 4
        fillMode: Image.PreserveAspectCrop
        visible: (images&&images.length > 0)
        source: (images&&images.length > 0) ? images[0].image : "icons/image.png"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                stack.push( "qrc:///ImageManager.qml", { date: date } );
            }
        }

    }

    Label {
        id: notesIndicator
        width: height
        anchors.top: parent.top
        anchors.left: imageIndicator.right
        anchors.bottom: parent.bottom
        anchors.margins: 4
        visible: (notes&&notes.length > 0)
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
        text: (notes&&notes.length > 0) ? notes[ 0 ].note : ""

        background: Canvas { // 'document' icon background
            anchors.fill: parent
            onPaint: {
                var foldOffset = width / 8.;
                var ctx = getContext("2d");
                ctx.resetTransform();
                ctx.fillStyle = Colours.lightSlate;
                ctx.strokeStyle = Colours.darkSlate;
                ctx.lineWidth = 2;

                ctx.beginPath();
                ctx.rect(0,0,width,height);
                ctx.moveTo( 0., foldOffset );
                ctx.lineTo( foldOffset, 0. );
                ctx.fill();
                ctx.stroke();
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                stack.push( "qrc:///NotesManager.qml", { date: date } );
            }
        }
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
        values: dailyModel.valuesForDate(date)
    }
    //
    //
    //
    property var date: 0
    property var images: []
    property var notes: []
    property var values: []
}
