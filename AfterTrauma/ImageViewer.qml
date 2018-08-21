import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.0
import SodaControls 1.0

import "controls" as AfterTrauma
import "colours.js" as Colours

Rectangle {
    id: container
    color: Colours.veryDarkSlate
    visible: false
    //
    //
    //
    Flickable {
        id: imageContainer
        anchors.fill: parent
        //
        //
        //
        Image {
            id: image
            anchors.fill: parent
            transformOrigin: Item.Center
            //
            //
            //
            onStatusChanged: {
                if ( status === Image.Ready ) {
                    scale = Math.min( width / implicitWidth, height / implicitHeight );
                    //var offsetX = width - ( implicitWidth * scale );
                    //var offsetY = height - ( implicitHeight * scale );
                }
            }
        }
    }
    //
    //
    //
    PinchArea {
        anchors.fill: parent
        //
        //
        //
        onPinchStarted: {
            startScale = image.scale;
        }
        onPinchUpdated: {
            console.log( 'scale : ' + pinch.scale );
            image.scale = startScale * pinch.scale;
        }
        onPinchFinished: {
            imageContainer.returnToBounds();
        }
        //
        //
        //
        property real startScale: 1.
    }
    //
    //
    //
    AfterTrauma.Button {
        id: closeButton
        width: 48
        height: 48
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 8
        image: "icons/close.png"
        onClicked: {
            hide();
        }
    }
    //
    //
    //
    function show( imageSource ) {
        parent = appWindow.contentItem;
        image.source = imageSource;
        visible = true;
    }
    function hide() {
        visible = false;
        parent = originalParent;
        image.source = "";
    }
    //
    //
    //
    property alias source: image.source
    property Item originalParent: parent
}
